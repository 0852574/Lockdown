extends Node3D

@onready var dropLocation = $"Item Spawn Location"
var rng = RandomNumberGenerator.new()
var weaponDrop = preload("res://Scenes/Weapon Drop.tscn")
var itemPaths = [
"res://Items/Item Files/Gem.tres",
"res://Items/Item Files/Goldbar.tres",
"res://Items/Item Files/Painting.tres"

]



func _ready() -> void:
	rng.randomize()
	Global.roundReset.connect(spawnItem)
	Global.playerJoined.connect(spawnItem)

func spawnItem():
	if multiplayer.get_unique_id() != 1:
		return
		
	# 1. Pick item and position immediately (no waiting)
	var loadedItem = itemPaths[rng.randi_range(0, itemPaths.size()-1)]
	var dropPos = dropLocation.global_position
	
	var dropName = "Item Drop %d" % rng.randi_range(1, 10000)
	var world = get_tree().root.get_node_or_null("World")
	while world and world.has_node(dropName):
		dropName = "Item Drop %d" % rng.randi_range(1, 10000)
		
	# 2. Tell all peers (including server via call_local) to spawn it instantly
	rpc("replicateDroppedItem", loadedItem, dropPos, dropName)

@rpc("authority", "call_local", "reliable")
func replicateDroppedItem(weapon, dropPos, dropName):
	# Safety check: Prevent duplicate spawns if packet arrives twice
	var world = get_tree().root.get_node_or_null("World")
	if not world or world.has_node(dropName):
		return
		
	var dropInstance = weaponDrop.instantiate()
	dropInstance.name = dropName
	world.add_child(dropInstance)
	
	# Configure item properties safely
	dropInstance.global_position = dropPos
	dropInstance.setWeapon(weapon)
	dropInstance.setModel(weapon)
	dropInstance.setAttribute("isItem", true)
	
	if multiplayer.is_server():
		get_tree().current_scene.totalItems += 1
