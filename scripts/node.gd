extends Control

onready var label = $label
onready var label_text
onready var label_2 = $label2
onready var x_text
onready var children_line = $children_line
onready var bottem_right = $bottem_right

onready var bottem_left = $bottem_left
onready var middle_child = $middle_child

func _ready():
	
	children_line.hide()
	bottem_left.hide()
	bottem_right.hide()
	middle_child.hide()
	if label_text != null:
		label.text = label_text
	if x_text != null:
		label_2.text = str(x_text)
	
func init(letter, x_val, has_children, is_bottem_left, is_bottem_right, is_middle_child):
	label.text = str(letter)
	label_2.text = str(x_val)
	if has_children:
		children_line.show()
	if is_bottem_left:
		bottem_left.show()
	if is_bottem_right:
		bottem_right.show()
	if is_middle_child:
		middle_child.show()
	
