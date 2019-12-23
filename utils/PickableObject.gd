extends RigidBody

onready var original_parent = get_parent()
var original_collision_mask
var original_collision_layer
var original_mode

# export var max_velocity = 10
var holding = null


func _ready():
    original_collision_mask = collision_mask
    original_collision_layer = collision_layer


func pick_up(by):
    if holding != by:
        if holding:
            let_go()

        holding = by
        original_mode = mode
        mode = RigidBody.MODE_STATIC
        collision_layer = 0
        collision_mask = 0

        original_parent.remove_child(self)
        holding.add_child(self)
        transform = Transform.IDENTITY


func let_go(impulse=Vector3.ZERO):
    if holding:
        var t = global_transform
        holding.remove_child(self)
        original_parent.add_child(self)

        global_transform = t
        mode = original_mode
        collision_mask = original_collision_mask
        collision_layer = original_collision_layer
        apply_impulse(Vector3.ZERO, impulse)

        holding = null
