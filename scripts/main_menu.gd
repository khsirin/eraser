extends Control

@onready var continue_button := %Continue

@onready var settings_menu := $Settings

func _ready():
    continue_button.disabled = not Saving.has_game_save_data()

func _on_new_game_pressed():
    if Saving.has_game_save_data():
        Saving.remove_game_save_data()

    Game.begin_game()

func _on_continue_pressed():
    Game.begin_game()

func _on_quit_pressed():
    get_tree().quit()

func _on_settings_pressed():
    settings_menu.visible = true