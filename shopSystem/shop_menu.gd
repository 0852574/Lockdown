extends Control


var money : int = 0:
	set(value):
		money = value
		
		$UI/Currency.text = "Money : " + str(value)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$UI.hide()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

enum MODE {
	ON,
	OFF
}

var mode : MODE = MODE.OFF:
	set(value):
		mode = value
		if value == MODE.OFF:
			$UI.hide()
		elif value == MODE.ON:
			$UI.show()

func _input(event):
	if event is InputEventKey and event.is_pressed():
		if event.keycode == KEY_O:
			if mode == MODE.ON:
				mode = MODE.OFF
			elif mode == MODE.OFF:
				mode = MODE.ON
	
