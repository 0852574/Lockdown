extends Node
# Manages players wallet

var bank_balance: int = 100
var money_total_value_earned_this_level: int = 0

# Call this when a money is collected
func money_collected(money_value: int) -> void:
	money_total_value_earned_this_level += money_value

# Called when level started or restarted
func reset_money_earned() -> void:
	money_total_value_earned_this_level = 0

# Called when level completed
func consolidate_bank_balance():
	bank_balance += money_total_value_earned_this_level
	reset_money_earned()

# Call whenever you need money earned this level 
func get_money_earned_this_level() -> int:
	return money_total_value_earned_this_level 

# Call whenever you need the bank balance, say in your shop, on a menu screen...
func get_bank_balance() -> int:
	return bank_balance
