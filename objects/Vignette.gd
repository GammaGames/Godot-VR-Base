extends ColorRect

onready var player = get_parent().get_parent()

func _ready():
    yield(get_tree(), "idle_frame")
    yield(get_tree(), "idle_frame")
    yield(get_tree(), "idle_frame")
    yield(get_tree(), "idle_frame")

    var interface = ARVRServer.get_primary_interface()
    rect_size = interface.get_render_targetsize()
    rect_position = Vector2(0, 0)


func _process(delta):
    var speed = player.linear_velocity.length()
    if speed > 1:
        visible = true
        color.a = ease(speed / player.max_velocity, 1.5)
    else:
        visible = false
