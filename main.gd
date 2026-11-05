extends CharacterBody3D

#Movement Settings
@export var walk_speed: float = 4.5
@export var sprint_speed: float = 7.0
@export var jump_velocity: float = 4.5
@export var mouse_sensivity: float = 0.002

#Gravity
var Gravity: float = 9.8

#Camera Reference
@onready var Camera = Camera3D = $Head/Camera3D

func _ready() -> void:
    Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func _unhandled_input(event: InputEvent) -> void:
    if event is InputEventMouseMotion:
        rotate_y(-event.relative.x * mouse_sensivity)

        camera.rotate_x(
            -event.relative.y * mouse_sensivity
        )

        camera.rotation.x = clamp(
            camera.rotation.x,
            deg_to_rad(-80)
            deg_to_rad(80)
        )
    if event.is_action_pressed("ui_cancel"):
        Input.mouse_mode = Input.MOUSE_MODE_VISIBLE

func _physics process(delta: float) -> void:
    handle_movement(delta)
    move_and_slide()

func handle_movement(delta: float) -> void:
    #apply gravity
    if not is_on_floor():
        velocity.y -= gravity * delta

    #Jump
    if Input.is_action_just_pressed("jump") and is_on_floor():
        velocity.y = jump_velocity

#Get movement input
var input_direction := Input.get_vector(
    "move_left",
    "move_right",
    "move_back",
    "move_forward"
)    

#COnvert input into world direction
var direction := (
    transform.basis *
    Vector3(input_direction.x, 0, input_direction.y)        
).normalized()

#Select movement speed
var current_Speed := walk_speed

if Input.is_action_pressed("sprint"):
    current_Speed = sprint_speed

#Apply horizontal movement
if direction:
    velocity.x = direction.x * current_Speed
    velocity.z - direction.z * current_Speed

else:
    velocity.x = move_toward(velocity.x, 0, current_Speed)
    velocity.z = move_toward(velocity.z, 0, current_Speed)
