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
	
	create_layout(root)
	apply_mod(root)

func create_layout(tree):
	
	

		
	for i in range(tree.children.size()):
		
		#if node is a tree
		if tree.children[i].children.size() > 0:
			
			
			#add a mod to separate the children
			#if it has siblings to the left
			if i > 0:
				
			
				tree.children[i].add_sibling_x(tree, i)
				tree.children[i].center_parent_mod()
		
				
			if i == 0:
				# centering children if the node is the leftmost child

				var value : float = 0.0
				for k in range(tree.children[i].children.size()):
					value += tree.children[i].children[k].x_val
				tree.children[i].x_val = value / 2
	
			
		elif i > 0:
			tree.children[i].add_sibling_x(tree, i)
		create_layout(tree.children[i])	
		# if node is a leaf
	
		
	

func apply_mod(tree):
	
	
	for i in range(tree.children.size()):
		#if node is a tree
		if tree.children[i].children.size() > 0:
		
			if tree.children[i].mod != 0:
				tree.children[i].mod_children(tree.children[i].mod)
			apply_mod(tree.children[i])
			
		# if node is childless :(
		else:
			apply_mod(tree.children[i])
			
	
	var node_tree = node.instance()

	add_child(node_tree)
	
	node_tree.init(tree.val, tree.x_val)
	var row_y = calc_y(tree.row)
	print("tree.val " , tree.val)
	print("tree.x_val ", tree.x_val)
	print("tree.mod ", tree.mod)
	var x = calc_x(tree.x_val + 1, tree.parent_mod)
	
	node_tree.rect_global_position = Vector2(x  ,row_y)
	


func calc_x(ind, mod):
	#converting mod and ind to node size
	if mod != null:
		mod = mod * 64
	else:
		mod = 0
	#64 is the size of each mode
	ind = ind * 64
	return ind + mod

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
