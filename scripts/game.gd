extends Node

signal on_pause_toggled

@onready var pause_menu_scene := preload("res://pause_menu.tscn")

var is_playing: bool
var is_paused: bool

var pause_menu_instance: SubViewportContainer

func _ready():
    process_mode = Node.PROCESS_MODE_ALWAYS

func begin_game():
    if is_playing:
        return
    
    is_playing = true
    is_paused = false

    get_tree().change_scene_to_file("res://world.tscn")
    pause_menu_instance = pause_menu_scene.instantiate()
    get_tree().root.add_child(pause_menu_instance)

func end_game():
    if not is_playing:
        return
    
    is_playing = false
    is_paused = false
    get_tree().paused = false
    Cursor.remove_cursor()

    get_tree().change_scene_to_file("res://main_menu.tscn")
    pause_menu_instance.queue_free()
    pause_menu_instance = null

func toggle_pause():
    is_paused = not is_paused
    get_tree().paused = is_paused
    on_pause_toggled.emit()