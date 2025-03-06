extends Control

@onready var go_back_button: Button = %GoBack
@onready var level_container: GridContainer = $Panel/HBoxContainer/VBoxContainer/ButtonContainer/levelContainer
@onready var level_1_button: Button = $Panel/HBoxContainer/VBoxContainer/ButtonContainer/levelContainer/Level1
@onready var level_2_button: Button = $Panel/HBoxContainer/VBoxContainer/ButtonContainer/levelContainer/Level2
@onready var level_3_button: Button = $Panel/HBoxContainer/VBoxContainer/ButtonContainer/levelContainer/Level3
@onready var level_4_button: Button = $Panel/HBoxContainer/VBoxContainer/ButtonContainer/levelContainer/Level4
@onready var level_5_button: Button = $Panel/HBoxContainer/VBoxContainer/ButtonContainer/levelContainer/Level5


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	
	level_1_button.pressed.connect(SceneManager.selectLevel.bind(0))
	level_2_button.pressed.connect(SceneManager.selectLevel.bind(1))
	level_3_button.pressed.connect(SceneManager.selectLevel.bind(2))
	level_4_button.pressed.connect(SceneManager.selectLevel.bind(3))
	level_5_button.pressed.connect(SceneManager.selectLevel.bind(4))
	go_back_button.pressed.connect(SceneManager.open_main_menu)
		
