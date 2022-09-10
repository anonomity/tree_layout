extends Node

# array of numbers, each number is how many columns in that row
var rows = []

func init_rows(row):
	if rows.size()-1 != row:
		rows.append(0)

func inc_row(row):
	rows[row] = rows[row] + 1

	return rows
	
	


