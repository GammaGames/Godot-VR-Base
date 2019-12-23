extends Area

onready var player = get_node("../../..")

export var impulse_factor = 100.0
var pickable_objects = []
var usable_objects = []
var picked_up = null
var last_pos = Vector3.ZERO
var velocity = Vector3.ZERO


func _ready():
    last_pos = global_transform.origin
    connect("body_entered", self, "_on_body_entered")
    connect("body_exited", self, "_on_body_exited")
    get_parent().connect("button_pressed", self, "_on_button_pressed")
    get_parent().connect("button_release", self, "_on_button_release")


func _process(delta):
    velocity = global_transform.origin - last_pos
    last_pos = global_transform.origin


func _on_body_entered(body):
    # If they can be picked up, add to objects
    if body.has_method("pick_up") and pickable_objects.find(body) == -1:
        pickable_objects.push_back(body)
    # If they can be used and not picked up, add to usable
    elif body.has_method("use") and usable_objects.find(body) == -1:
        usable_objects.push_back(body)


func _on_body_exited(body):
    if pickable_objects.find(body) != -1:
        pickable_objects.erase(body)
    if usable_objects.find(body) != -1:
        usable_objects.erase(body)


func _on_button_pressed(button):
    if button == Controls.BUTTON_GRIP and !pickable_objects.empty():
        picked_up = get_closest_object(pickable_objects)
        picked_up.pick_up(self)
        $"../Controller_mesh".visible = false
    elif button == Controls.BUTTON_TRIGGER:
        if picked_up and picked_up.has_method("use"):
            picked_up.use(self)
        elif len(usable_objects) > 0:
            var closest = get_closest_object(usable_objects)
            if closest.has_method("use"):
                closest.use(self)
    elif button == Controls.BUTTON_A:
        if picked_up and picked_up.has_method("alt_use"):
            picked_up.alt_use(self)
        elif len(usable_objects) > 0:
            var closest = get_closest_object(usable_objects)
            if closest.has_method("alt_use"):
                closest.alt_use(self)


func _on_button_release(button):
    if button == Controls.BUTTON_GRIP and picked_up:
        picked_up.let_go(velocity * impulse_factor)
        picked_up = null
        $"../Controller_mesh".visible = true
    elif button == Controls.BUTTON_TRIGGER:
        if picked_up and picked_up.has_method("unuse"):
            picked_up.unuse()
        elif len(usable_objects) > 0:
            var closest = get_closest_object(usable_objects)
            if closest.has_method("unuse"):
                closest.unuse()
    elif button == Controls.BUTTON_TRIGGER and picked_up and picked_up.has_method("unuse"):
        picked_up.unuse()
    elif button == Controls.BUTTON_A:
        if picked_up and picked_up.has_method("alt_unuse"):
            picked_up.alt_unuse()
        elif len(usable_objects) > 0:
            var closest = get_closest_object(usable_objects)
            if closest.has_method("alt_unuse"):
                closest.alt_unuse()


func get_closest_object(list):
    var closest = null
    var closest_distance = INF
    for object in list:
        var distance = global_transform.origin.distance_to(object.global_transform.origin)
        if distance < closest_distance:
            closest = object
            closest_distance = distance

    return closest
