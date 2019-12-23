extends Area

onready var player = get_node("../../..")

export var impulse_factor = 100.0
var holdable_objects = []
var usable_objects = []
var holding = null
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
    if body.has_method("hold") and holdable_objects.find(body) == -1:
        holdable_objects.push_back(body)
    elif body.has_method("use") and usable_objects.find(body) == -1:
        usable_objects.push_back(body)


func _on_body_exited(body):
    if holdable_objects.find(body) != -1:
        holdable_objects.erase(body)
    if usable_objects.find(body) != -1:
        usable_objects.erase(body)


func _on_button_pressed(button):
    if button == Controls.BUTTON_GRIP and !holdable_objects.empty():
        holding = get_closest_object(holdable_objects)
        holding.hold(self)
    # elif button == Controls.BUTTON_TRIGGER:
    #     print(button)
    #     if holding and holding.has_method("use"):
    #         holding.use(get_parent(), player)
        # elif len(usable_objects) > 0:
        #     get_closest_object(usable_objects).use(get_parent(), player)


func _on_button_release(button):
    if button == Controls.BUTTON_GRIP and holding:
        holding.drop(velocity * impulse_factor)
        holding = null
    # elif button == Controls.BUTTON_TRIGGER and holding and holding.has_method("unuse"):
    #     print(button)
    #     holding.unuse()


func get_closest_object(list):
    var closest = null
    var closest_distance = INF
    for object in list:
        var distance = global_transform.origin.distance_to(object.global_transform.origin)
        if distance < closest_distance:
            closest = object
            closest_distance = distance

    return closest
