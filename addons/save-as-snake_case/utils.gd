tool
extends Resource

#=================== EditorFileDialog Utils ================
# todo: find a better way.
static func editor_file_dialog_get_line_edit(node:EditorFileDialog):
	return find_node_by_class_path(node, ['VBoxContainer', 'HSplitContainer', 'VBoxContainer', 'HBoxContainer', 'LineEdit'])

#=================== ScriptDialog Utils ================
static func get_script_dialog_lineedit(plugin:EditorPlugin):
	return find_node_by_class_path(
		plugin.get_script_create_dialog(),
		['HBoxContainer',
		'VBoxContainer',
		'GridContainer',
		'HBoxContainer',
		'LineEdit'])

#=================== Node Utils ================

static func get_nodes_by_filter(node:Node, filter_obj:Object, filter_method:String, arg: = [])->Array:
	var res:= []
	var nodes = []
	var stack = [node]
	while stack:
		var n = stack.pop_back()
		if filter_obj.call(filter_method, n, arg):
			res.push_back(n)
		nodes.push_back(n)
		stack.append_array(n.get_children())
	return res



static func find_node_by_class_path(node:Node, class_path:Array)->Node:
	var res:Node

	var stack = []
	var depths = []

	var first = class_path[0]
	for c in node.get_children():
		if c.get_class() == first:
			stack.push_back(c)
			depths.push_back(0)

	if not stack: return res
	
	var max_ = class_path.size()-1

	while stack:
		var d = depths.pop_back()
		var n = stack.pop_back()

		if d>max_:
			continue
		if n.get_class() == class_path[d]:
			if d == max_:
				res = n
				return res

			for c in n.get_children():
				stack.push_back(c)
				depths.push_back(d+1)

	return res


#=================== String Utils ================
var upseq_up_low:RegEx
var low_up:RegEx

func _init():
	upseq_up_low = RegEx.new()
	upseq_up_low.compile("([A-Z]+)([A-Z][a-z])")

	low_up = RegEx.new()
	low_up.compile('([a-z])([A-Z])')	


func to_snake(name:String, replace_spaces:=true):
	name =  upseq_up_low.sub(name, '$1_$2')
	name =  low_up.sub(name, '$1_$2').to_lower()
	return name.replace(' ', '_') if replace_spaces else name
