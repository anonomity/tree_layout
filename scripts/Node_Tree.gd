extends Node


class_name Node_Tree

# array of node tree
var children = []

var row 
var val
var parent
var x_val
var mod = 0

var id
var rng = RandomNumberGenerator.new()



func _init(_row, _val, _parent):
	if _row == 0:
		x_val = 0
	row = _row
	val = _val
	if _parent != null:
		parent = _parent
		
	rng.randomize()
	var my_random_number = rng.randf_range(0, 1000000)
	var id = String(val) + String(int(my_random_number))
	GlobalTreeVariable.init_rows(_row)



func mod_with_account_of_children():
	for child in children:
		
		mod += child.mod
#	mod += children.size()/2
	print("node ", val, " mod ", mod)

func mod_children(mod_num):
	for i in range(children.size()):
		children[i].mod = mod_num
		print("node ", children[i].val, " mod ", children[i].mod)
	
	
func add_node(instance : Node_Tree):
	
	var new_row = GlobalTreeVariable.inc_row(instance.row)
	instance.x_val = GlobalTreeVariable.rows[instance.row]
	
#	print("node ", instance.val , " x_val ", instance.x_val)
	
	children.append(instance)
	

func get_x_val():
	return x_val

