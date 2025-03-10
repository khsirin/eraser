extends State

signal set_return_patrol_point

@export var plane: PlaneBody
@export var status_texture: Texture2D
@export var reach_radius: float
@export var speed: float
@export var detect_time: float

var patrol_points: Array[Node2D]
var current_point: int

var detect_charge_time: float

func enter():
    patrol_points.clear()

    for child in plane.patrol_points.get_children():
        patrol_points.append(child)

    if current_point == null:
        current_point = patrol_points.find(plane.get_closest_patrol_point())
    
    plane.set_state_indicator(status_texture)

func update(delta: float):
    if plane.player_raycast.is_colliding() and plane.player_raycast.get_collider() == Player.instance:
        detect_charge_time += delta
    else:
        detect_charge_time = max(0, detect_charge_time - delta)

    if detect_charge_time >= detect_time:
        detect_charge_time = 0

        set_return_patrol_point.emit()
        transition.emit("detect_shock")

func physics_update(_delta: float):
    var target_point = patrol_points[current_point].global_position

    var difference = target_point - plane.global_position

    if difference.length() <= reach_radius:
        current_point += 1
        
        if current_point >= patrol_points.size():
            current_point = 0
    
    plane.velocity = difference.normalized() * speed

func exit():
    plane.set_state_indicator(null)
