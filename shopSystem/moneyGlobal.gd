extends Node

var player_money: Dictionary = {}


func add_player(id: int):
	player_money[id] = 0 # Player starting money
