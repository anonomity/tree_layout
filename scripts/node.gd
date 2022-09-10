extends Control

onready var label = $label
onready var label_text
onready var label_2 = $label2
onready var x_text

func _ready():
	if label_text != null:
		label.text = label_text
	if x_text != null:
		label_2.text = str(x_text)
	
func init(letter, x_val):
	label.text = str(letter)
	label_2.text = str(x_val)
