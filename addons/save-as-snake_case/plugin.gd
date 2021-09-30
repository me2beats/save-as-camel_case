tool
extends EditorPlugin

const Utils = preload("utils.tres")

func _enter_tree():
	var base = get_editor_interface().get_base_control()
	var target_file_dialogs = Utils.get_nodes_by_filter(base, self, 'is_file_dialog_save')
	for n in target_file_dialogs:
		n.connect("about_to_show",self, "on_show", [n])

	var script_dialog = get_script_create_dialog()
	var script_dialog_lineedit = Utils.get_script_dialog_lineedit(self)
	script_dialog.connect("about_to_show", self, "on_script_dialog_show", [script_dialog_lineedit])

func on_show(node:EditorFileDialog):
	var lineedit = Utils.editor_file_dialog_get_line_edit(node)
	var text:String = lineedit.text
	lineedit.text = Utils.to_snake(text)


func on_script_dialog_show(lineedit:LineEdit):
	var text:String = lineedit.text
	lineedit.text = Utils.to_snake(text)

static func is_file_dialog_save(node:Node, _arg):
	return node is EditorFileDialog and (node as EditorFileDialog).mode == node.MODE_SAVE_FILE

