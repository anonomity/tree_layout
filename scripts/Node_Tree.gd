extends Node


class_name Node_Tree

# array of node tree
var children = []

var row 
var val
var parent
var x_val : float
var mod :float
var index :float = 0
var id
var rng = RandomNumberGenerator.new()
var parent_mod : float = 0
var rightmost_padding = []
var leftmost_padding = []
var left_child = false
var middle_child = false
var right_child = false

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

func mod_children(mod_val):
	for child in children:
		
		#if the node has children
		if child.children.size() > 0:
			
			child.mod_children(mod_val)
#		print("changing ", child.val, ": ", child.x_val , " to : ", child.x_val +mod_val)
		child.parent_mod += mod_val

func add_sibling_x(tree, ind):
	x_val += tree.children[ind - 1].x_val
#	print("adding ", tree.children[ind - 1].x_val , " to ", val," making it ", x_val)

func delete_parent_mod():
	for child in children:
		if child.children.size() > 0:
			child.delete_parent_mod()
		child.parent_mod = 0

func center_root():
	var prelim_x = 0
	for i in range(children.size()):
		if i ==0 or i == children.size()-1:
			prelim_x += children[i].x_val
			prelim_x += children[i].parent_mod

	x_val = abs(x_val - prelim_x/2)


func center_parent_mod():
	
	var prelim_x = 0
	for child in children:
		prelim_x += child.x_val
	mod = x_val - prelim_x/2

# fills an array with the trees leftmost and rightmost child posisiotn
func check_subtree_padding(leftmost_arr, rightmost_arr):
	for i in range(children.size()):
		if i ==0:
			leftmost_arr.append(children[i].x_val + children[i].parent_mod)
			if (children.size()-1) == 0:
				rightmost_arr.append(children[i].x_val + children[i].parent_mod)
		elif i == (children.size() - 1):
			rightmost_arr.append(children[i].x_val + children[i].parent_mod)
		
		if children[i].children.size() > 0:
			children[i].check_subtree_padding(leftmost_arr,rightmost_arr)

func recalculate_children_separation(separation, mama):
	for i in range(mama.children.size()):
		#we dont want to adjust first or last 1
		if i != 0 and i != mama.children.size()-1:
			var shift_val = separation / (i + 1)
			mama.children[i].x_val += shift_val

func adjust_mod(new_mod):
	mod += new_mod
	x_val += new_mod
	delete_parent_mod()
	
func delete_padding():
	for i in range(children.size()):
		leftmost_padding.clear()
		rightmost_padding.clear()
		children[i].delete_padding()
	

func pad_subtree(new_mod):
	mod += new_mod
	x_val += new_mod

	

func add_node(instance : Node_Tree):
	if children.size() > 1:
		instance.x_val = 1
	else:
		instance.x_val = children.size()
	children.append(instance)
	

func get_x_val():
	return x_val

