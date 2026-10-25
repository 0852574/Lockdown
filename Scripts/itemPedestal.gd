extends Node3D

@onready var dropLocation = $"Item Spawn Location"
var rng = RandomNumberGenerator.new()
var weaponDrop = preload("res://Scenes/Weapon Drop.tscn")
var itemPaths = [
	"res://Items/Item Files/Amythest.tres",
	"res://Items/Item Files/Emerald.tres",
	"res://Items/Item Files/Gem.tres",
	"res://Items/Item Files/Goldbar.tres",
	"res://Items/Item Files/Painting.tres",
	"res://Items/Item Files/Potion.tres",
	"res://Items/Item Files/Star.tres",
	"res://Items/Item Files/Vase.tres"
]

var spawned_items = []
var _has_spawned_this_round = false  # ← NEW: Prevents double-spawn per round

func _ready() -> void:
	rng.randomize()
	Global.roundReset.connect(_on_round_reset)
	Global.joinButtonPressed.connect(requestItems)
	Global.playerJoined.connect(_on_player_joined)

# ← NEW: Reset the guard when a new round starts
func _on_round_reset():
	_has_spawned_this_round = false
	spawnItem()

# ← NEW: Only spawn on player join if we haven't already spawned this round
func _on_player_joined():
	if not _has_spawned_this_round:
		spawnItem()

func requestItems():
	if not multiplayer.is_server():
		rpc_id(1, "request_item_sync")

func spawnItem():
	if not multiplayer.is_server():
		return
	
	# ← CRITICAL: Block duplicate spawns within the same round
	if _has_spawned_this_round:
		return
	_has_spawned_this_round = true
	
	var loadedItem = itemPaths[rng.randi_range(0, itemPaths.size()-1)]
	var dropPos = dropLocation.global_position
	
	var dropName = "Item Drop %d" % rng.randi_range(1, 10000)
	while has_node(dropName):
		dropName = "Item Drop %d" % rng.randi_range(1, 10000)
		
	spawned_items.append({
		"weapon": loadedItem,
		"pos": dropPos,
		"name": dropName
	})
	
	rpc("replicateDroppedItem", loadedItem, dropPos, dropName)

@rpc("authority", "call_local", "reliable")
func replicateDroppedItem(weapon, dropPos, dropName):
	if has_node(dropName):
		return
		
	var dropInstance = weaponDrop.instantiate()
	dropInstance.name = dropName
	add_child(dropInstance) 
	
	dropInstance.global_position = dropPos
	dropInstance.setWeapon(weapon)
	dropInstance.setModel(weapon)
	dropInstance.setAttribute("isItem", true)
	
	if multiplayer.is_server():
		if get_tree().current_scene:
			get_tree().current_scene.totalItems += 1

@rpc("any_peer", "reliable")
func request_item_sync():
	if not multiplayer.is_server():
		return
	
	var sender_id = multiplayer.get_remote_sender_id()
	for item in spawned_items:
		rpc_id(sender_id, "replicateDroppedItem", item.weapon, item.pos, item.name)

func clear_items():
	spawned_items.clear()
	_has_spawned_this_round = false  # ← Also reset here
	for child in get_children():
		if child.name.begins_with("Item Drop"):
			child.queue_free()
