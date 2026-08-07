extends Node3D

var itemCount = 0
@onready var area3D = $Area3D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_area_3d_body_entered(body: Node3D) -> void:
	if body.has_method("getPrice"):
		itemCount += 1
		print(itemCount)
		Global.totalValue += body.getPrice()
		if Global.myCurrentTeam == "Robber":
			Global.updatePoints()
		if get_tree().current_scene.totalItems == itemCount:
			get_tree().current_scene.resetRound()
			itemCount = 0
			var bodies = area3D.get_overlapping_bodies()
			for i in bodies:
				if i.has_method("getPrice"):
					i.queue_free()
			
			

func _on_area_3d_body_exited(body: Node3D) -> void:
	if body.has_method("getPrice"):
		Global.totalValue -= body.getPrice()
		if Global.myCurrentTeam == "Robber":
			Global.updatePoints()
