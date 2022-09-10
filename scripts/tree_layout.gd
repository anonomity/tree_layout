extends Control


var leftmost_x 

var row = 0

var row_y = 64 + (76 * (row - 1))

onready var node = preload("res://screnes/node.tscn")

func _ready():
	
	#initializing the whole tree with row and val and parent
	var root = Node_Tree.new(0,"O", null)
	
	var node1 = Node_Tree.new(1, "E",root)
	var node2 = Node_Tree.new(1, "F",root)
	var node3 = Node_Tree.new(1, "N",root)
	var node4 = Node_Tree.new(2, "A", node1)
	var node5 = Node_Tree.new(2, "D", node1)
	var node6 = Node_Tree.new(2, "G", node3)
	var node7 = Node_Tree.new(2, "M", node3)
	var node8 = Node_Tree.new(3, "B", node5)
	var node9 = Node_Tree.new(3, "C", node5)
	var node10 = Node_Tree.new(3, "H", node7)
	var node11 = Node_Tree.new(3, "I", node7)
	var node12 = Node_Tree.new(3, "J", node7)
	var node13 = Node_Tree.new(3, "K", node7)
	var node14 = Node_Tree.new(3, "L", node7)
	
	var nodes = [node1, node2, node3, node4, node5, node6, node7, node8, node9, node10, node11, node12, node13, node14]
#	create_tree(root, nodes)
	
	
	# we start at the bottom most trees whose children are the leaves
	# inificient way of doing it for the time being
	node5.add_node(node8)
	node5.add_node(node9)
	
	node7.add_node(node10)
	node7.add_node(node11)
	node7.add_node(node12)
	node7.add_node(node13)
	node7.add_node(node14)
	
	node1.add_node(node4)
	node1.add_node(node5)
	
	node3.add_node(node6)
	node3.add_node(node7)
	
	root.add_node(node1)
	root.add_node(node2)
	root.add_node(node3)
	
	create_layout(root,0)
	apply_mod(root)

func create_layout(tree , left_order):
	

#		tree.mod = (tree.children.size()  / 2) 
		
	for i in range(tree.children.size()):
		
		#if node has children 
		if tree.children[i].children.size() > 0:
			#if its not the leftmost node
			if i > 0:
				
				tree.children[i].mod_children(tree.children[i].x_val / 2)
				tree.children[i].inc_x_prelim(i)
				#inc by the siblings prelim_x
				tree.children[i].inc_sibling_prelim_x()
#				
			else:
				print("i", i, " is not leftmost ", tree.children[i].val)
				for child in tree.children:
					child.mod = tree.children[i].children.size() / 2
				
			create_layout(tree.children[i],i+1)
				
		# if node is childless :(
		else:
			if i > 0:
				
				tree.children[i].mod_children(tree.children[i].x_val / 2)
				tree.children[i].inc_x_prelim(i)
				#inc by the siblings prelim_x
				tree.children[i].inc_sibling_prelim_x()
			create_layout(tree.children[i],i+1)
		
	

func apply_mod(tree):
	if tree.row == 0:
		tree.mod_with_account_of_children()
	
	for i in range(tree.children.size()):
		#if node has children
		if tree.children[i].children.size() > 0:
			apply_mod(tree.children[i])
		# if node is childless :(
		else:
			apply_mod(tree.children[i])
	
	
	var node_tree = node.instance()

	add_child(node_tree)
	
	node_tree.init(tree.val, tree.x_val)
	var row_y = calc_y(tree.row)
	var x = calc_x(tree.x_val, tree.mod)
#	print("placing ", tree.val, " here: (", x, ",",row_y,")" )
	
	node_tree.rect_global_position = Vector2(x  ,row_y)
	


func calc_x(ind, mod):
	mod = mod * 64

	var x
	if ind == 0:
		x = 64
	else:
		x = ind * 64
	return x + mod

func calc_y(row):
	var row_y = 64 + (76 * (row))
	return row_y
	
func create_tree(root, nodes):
	#these are nodes that already were added to a tree
	var buffer = []
	
	for i in range(nodes.size()):
		var tree = nodes[i]
		
		#inificiently check for children
		for j in range(nodes.size()):
			if nodes[j].parent == tree.val:
				tree.add_node(nodes[j])
#				buffer.add_node(nodes[j])
		
		root.add_node(tree)
