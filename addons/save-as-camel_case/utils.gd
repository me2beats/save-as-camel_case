
#=================== EditorFileDialog Utils ================
# todo: find a better way.
static func editor_file_dialog_get_line_edit(node:EditorFileDialog):
	return find_node_by_class_path(node, ['VBoxContainer', 'HSplitContainer', 'VBoxContainer', 'HBoxContainer', 'LineEdit'])


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
static func pascal2snake(string:String)->String:
	var result = PoolStringArray()
	var recent_is_digit = false
	var recent_is_upper = false
	for ch in string:
		ch = ch as String

		if ch.is_valid_integer():
			recent_is_digit = true
			recent_is_upper = false
			result.append(ch)

		else:
			var lower = ch.to_lower()
			var is_upper = !ch==lower
			recent_is_upper = is_upper

			if recent_is_digit or recent_is_upper:
				result.append(lower)
			elif is_upper:
				result.append('_'+ch.to_lower())
			else:
				result.append(ch)

			recent_is_digit = false
			
	return result.join('')