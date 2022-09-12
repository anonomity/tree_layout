extends Control


var leftmost_x 

var row = 0

var row_y = 64 + (76 * (row - 1))

onready var node = preload("res://screnes/node.tscn")
onready var nodes = $nodes


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
	var node15 = Node_Tree.new(3, "Q", node4)
	var node17 = Node_Tree.new(3, "X", node4)
	var node16 = Node_Tree.new(3, "Y", node5)
#	var node17 = Node_Tree.new(2, "Z", node2)
	
	var nodes = [node1, node2, node3, node4, node5, node6, node7, node8, node9, node10, node11, node12, node13, node14, node15, node16, node17]
#	create_tree(root, nodes)
	
	
	# we start at the bottom most trees whose children are the leaves
	# inificient way of doing it for the time being
	node4.add_node(node15)
	node4.add_node(node17)
	
	node5.add_node(node8)
	node5.add_node(node9)
#	node5.add_node(node16)
	
	node7.add_node(node10)
	node7.add_node(node11)
	node7.add_node(node12)
	node7.add_node(node13)
	node7.add_node(node14)
#	node7.add_node(node15)
	
	
	
	
	node1.add_node(node4)
	node1.add_node(node5)
	
	node3.add_node(node6)
	node3.add_node(node7)
	
	root.add_node(node1)
	root.add_node(node2)
	root.add_node(node3)
	
	create_layout(root)
	apply_mod(root)
	clear_nodes()
	check_subtree_conflicts(root)
	clear_parent_mods(root)
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


func clear_parent_mods(tree):
	for i in range(tree.children.size()):
		tree.children[i].delete_parent_mod()
		
			

		
func clear_nodes():
	for n in nodes.get_children():
		nodes.remove_child(n)
		n.queue_free()

func apply_mod(tree):
	
	
	for i in range(tree.children.size()):
		#if node is a tree
		if tree.children[i].children.size() > 0:
		
			if tree.children[i].mod != 0:
				tree.children[i].mod_children(tree.children[i].mod)
		
		apply_mod(tree.children[i])
			
	draw_tree(tree)
	


func check_subtree_conflicts(tree):
	for i in range(tree.children.size()):
		check_subtree_conflicts(tree.children[i])
		if tree.children[i].children.size() > 0:
			tree.children[i].check_subtree_padding(tree.children[i].leftmost_padding,tree.children[i].rightmost_padding )
			
#		print(tree.children[i].val ," has padding of ", tree.children[i].leftmost_padding, " and ",tree.children[i].rightmost_padding)
	
	for j in range(tree.children.size()):
		
		#loop thru each subtree and make sure their rightmost ancestors don't interfere with sibling subtrees leftmost ancestors
		
		
		for k in range(tree.children[j].rightmost_padding.size()):
			if j+k < (tree.children.size()-1):
				#if right sibling node even has children padding values
				if tree.children[j+1 + k].leftmost_padding.size() > k:
					#adding 1 to take into account sibling separation 
					if tree.children[j].rightmost_padding[k]+ 1 >= tree.children[j+1+k].leftmost_padding[k]:
						
							var new_mod = tree.children[j+1+k].leftmost_padding[k] - tree.children[j].rightmost_padding[k]
							new_mod = 2 - new_mod
							tree.children[j+1+k].adjust_mod(new_mod)
							tree.children[j].center_parent_mod()
						# we need to mod tree.children[k+1]
		
	
			
func draw_tree(tree):
	var node_tree = node.instance()

	nodes.add_child(node_tree)
	
	node_tree.init(tree.val, tree.x_val)
	var row_y = calc_y(tree.row)
	print("tree.val " , tree.val)
	print("tree.x_val ", tree.x_val)
	print("tree.mod ", tree.mod)
	print("parent.mod ", tree.parent_mod)
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
