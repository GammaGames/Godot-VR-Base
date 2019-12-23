extends Spatial

onready var player = get_node("../../..")

export(float) var movement_speed = 175

func _physics_process(delta):
    # TODO player stops doing physics after moving?
    var controller = get_parent()
    if controller.get_is_active():
        var left_right = controller.get_joystick_axis(0)
        left_right = left_right if abs(left_right) > 0.1 else 0
        var forwards_backwards = controller.get_joystick_axis(1) * -1
        forwards_backwards = forwards_backwards if abs(forwards_backwards) > 0.1 else 0
        var forward = player.get_node("Player/ARVRCamera").global_transform.basis.get_euler().y
        var direction = Vector3(left_right, 0, forwards_backwards)
        direction = direction.rotated(Vector3.UP, forward)

        player.linear_velocity.x = direction.normalized().x * movement_speed * delta
        player.linear_velocity.z = direction.normalized().z * movement_speed * delta
