extends Control

@export var shop_slot_node : PackedScene = preload("res://shopSystem/shop_slot.tscn")
@export var shop_items : Array[Item]
@export var shop_container : VBoxContainer

var current_balance = moneyGlobal.get_bank_balance()
@onready var money = $UI/moneyLabel

func _ready() -> void:
	$UI.hide()
	load_shop_inventory()
	update_money_display()

func update_money_display() -> void:
	money.text = "Money: " + str(current_balance)

enum MODE {
	ON,
	OFF
}
 
var mode : MODE = MODE.OFF:
	set(value):
		mode = value
 
		if value == MODE.OFF:
			$UI.hide()
			Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
			Global.taskMode = false
		elif value == MODE.ON:
			$UI.show()
			Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
			Global.taskMode = true


func _input(event):
	if event is InputEventKey and event.is_pressed():
		if event.keycode == KEY_L:
			if mode == MODE.ON:
				mode = MODE.OFF
			elif mode == MODE.OFF:
				mode = MODE.ON
			print("shop op")

func sell_item(item : Item):
	if item == null:
		return
	money += item.price

func buy_item(item : Item):
	if item == null:
		return false
 
	if item.price > money:
		return false
 
	money -= item.price
	return true
	
func free_previous_slots():
	for slot in shop_container.get_children():
		slot.free()
 
func load_shop_inventory():
	for item in shop_items:
		var shop_slot = shop_slot_node.instantiate()
		shop_container.add_child(shop_slot)
		shop_slot.item = item
 
func set_shop_inventory(list : Array[Item]):
	free_previous_slots()
	shop_items = list
	load_shop_inventory()
