extends Panel

signal add_item

@export var item : Item:
	set(value):
		item = value
		$Icon.texture = value.icon
		$Price.text = "$ " + str(value.price)
		

func _on_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and Shop.mode == Shop.MODE.ON:
		if event.is_pressed() and event.button_index == MOUSE_BUTTON_LEFT:
			if Shop.buy_item(item):
				add_item.emit(item, 1)
				print("item added to inventory")
