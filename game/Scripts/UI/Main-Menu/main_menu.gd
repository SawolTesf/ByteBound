extends Control
@onready var new_game_button: Button = %New_Game
@onready var select_level_button: Button = %Select_Level
@onready var quit_button: Button = %Quit


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	new_game_button.pressed.connect(play)
	quit_button.pressed.connect(quit_game)

func play():
	SceneManager.current_level_path = 0
	SceneManager.load_level(SceneManager.level_paths[0])

func quit_game():
	get_tree().quit()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
