extends RigidBody

onready var original_parent = get_parent()
onready var origin  = $Player
onready var camera = $OVRFirstPerson/ARVRCamera
onready var collision = $CollisionShape

export var max_velocity = 15

func _integrate_forces(state):
    # Limit max speed
    var velocity = state.linear_velocity
    var speed = velocity.length()
    if speed and speed > max_velocity:
        state.linear_velocity = velocity.normalized() * max_velocity

    # Get origins
    var new_origin = collision.global_transform.origin
    # var vr_origin = origin.global_transform.origin
    var camera_origin = camera.global_transform.origin
    var camera_rotation = camera.rotation
    new_origin.x = camera_origin.x
    # new_origin.x += sin(camera_rotation.y) * 0.1
    new_origin.z = camera_origin.z
    # new_origin.z += cos(camera_rotation.y) * 0.1
    collision.global_transform.origin = new_origin
    # if camera_rotation.x > -0.6 or abs(collision.rotation.y - camera_rotation.y) > 1.0:
    # Get rotation for shape rotation
    # collision.rotation.y = camera_rotation.y
    # TODO use tan (or cos or sin) and linear_velocity to rotate shape forward
    # collision.rotation.y = atan2(linear_velocity.x, linear_velocity.z)
