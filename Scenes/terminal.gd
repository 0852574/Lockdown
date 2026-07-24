#extends Node3D
#
#@onready var GUI = $GUIwindow
#@onready var GUI_viewport = %SubViewport
#@export var GUI_window: Window 
## Called when the node enters the scene tree for the first time.
#func _ready() -> void:
	#pass # Replace with function body.
#
#
## Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
	#pass
#
#func _GUI_window_open(_body: Player) -> void:
	#var minitask = preload("res://gameMechanics/hacking_minitask.tscn").instantiate()
	#Input.mouse_mode = Input.MOUSE_MODE_VISIBLE # Release mouse
	#Global.taskMode = true
	#GUI.show()
	#GUI_viewport.add_child(minitask)
	#print("player interacted with minitask")
	#if GUI_window != null:
		#GUI_window.emit_signal("close_requested")
		#Global.taskMode = false
#
#
#func _on_Quit_button_pressed() -> void:
	#if player.is_multiplayer_authority():
		#Input.mouse_mode = Input.MOUSE_MODE_VISIBLE # Release mouse
		#Global.taskMode = true
		#GUI.show()
		#GUI_viewport.add_child(minitask)
		#print("player interacted with minitask")
#
## player quits window
		#if GUI_window != null:
			#swap_to_new_instance()
			#GUI_window.emit_signal("close_requested")
			#Global.taskMode = false
			#print("player closed minitask")
#
#func swap_to_new_instance():
	#if is_instance_valid(active_instance):
		#active_instance.queue_free()
		#var new_instance = minitask.instantiate()
		#add_child(new_instance)
		#active_instance = new_instance
