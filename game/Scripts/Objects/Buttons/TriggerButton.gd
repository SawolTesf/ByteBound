class_name TriggerButton extends Area2D
## This is the base class for all interactable buttons in the game excluding UI._add_constant_central_force
##
##
## These buttons will respond to the player character entering their area.
## each button will have a sprite that will play an animation when the button is pressed.
## Each Button will have a type called ButtonType
## The Animations should follow the following naming convention
##  - "Idle" The Button hasnt been activated
##  - "Transition" for the button being pressed (should not loop)
## Each TriggerButton will be added to the "Buttons" group
## Only deals with body_entered signal as not all buttons will do something upon leaving the area.

var is_activated: bool = false
# if activated by a pedestal this will be true, Keeps pressure plates from reactivating the lazer
var sprite: AnimatedSprite2D

# if no type is assigned in the subclass make the button a default
var type: Globals.ButtonType = Globals.ButtonType.DEFAULT

func _ready() -> void:
    add_to_group("Buttons")

    # Get the animated sprite node and check its not null
    sprite = get_node("AnimatedSprite2D")
    assert(sprite != null, "Button Sprite not found")

    # connect the signals
    body_entered.connect(_on_body_entered)


func signal_emiter() -> void:
    pass 


func _on_body_entered(body: Node2D) -> void:
    print("Button body entered")
    if body is Player:
        # Only emit the signal if the button is not already activated
        # Keeps the signal from emiting more then once per entering.
        if not is_activated:
            # Play the transition animation (button being pressed)
            sprite.play("Activate")

            # Set before the signal is emitted
            # Makes sure that on entering the activated signal is emitted
            is_activated = true

            # emit the proper signal
            signal_emiter()