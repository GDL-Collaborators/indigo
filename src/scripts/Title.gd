extends Node2D

signal select_input

onready var main_menu = get_tree().get_nodes_in_group('main_menu').front()
onready var options_menu = get_tree().get_nodes_in_group('options_menu').front()
onready var controls_menu = get_tree().get_nodes_in_group('controls_menu').front()
onready var control_editor = preload('res://ui/ControlEditor.tscn')

var controls_name_map = {
	'up': 'Move Up',
	'down': 'Move Down',
	'left': 'Move Left',
	'right': 'Move Right',
	'interact': 'Interact',
	'dog': 'Command Dog',
}

func _ready():
	main_menu.get_node('Button').connect('pressed', self, 'start_clicked')
	main_menu.get_node('Button2').connect('pressed', self, 'go_to_options')
	main_menu.get_node('Button3').connect('pressed', self, 'exit_clicked')

	options_menu.get_node('CheckButton').connect('toggled', self, 'animation_effect_toggle')
	options_menu.get_node('Button').connect('pressed', self, 'return_to_main')
	options_menu.get_node('Button2').connect('pressed', self, 'go_to_controls')

	controls_menu.get_node('Button3').connect('pressed', self, 'go_to_options')
	for name in InputMap.get_actions():
		if not name.begins_with('ui_'):
			var inst = control_editor.instance()
			inst.get_node('Name').text = controls_name_map.get(name, name)
			var actions = InputMap.get_action_list(name)
			inst.get_node('Assignment').text = actions.front().as_text()
			inst.get_node('Edit').connect('pressed', self, 'bind_input', [name, inst])
			controls_menu.add_child_below_node(controls_menu.get_node('Placeholder'), inst)

	return_to_main()
	GameUi.disable()

func start_clicked():
	GameState.start_game()
	GameUi.enable()

func go_to_options():
	main_menu.visible = false
	options_menu.visible = true
	controls_menu.visible = false
	options_menu.get_node('Button').grab_focus()

func go_to_controls():
	main_menu.visible = false
	options_menu.visible = false
	controls_menu.visible = true
	controls_menu.get_node('Button3').grab_focus()

func return_to_main():
	main_menu.visible = true
	options_menu.visible = false
	controls_menu.visible = false
	main_menu.get_node('Button').grab_focus()

func exit_clicked():
	get_tree().quit()

func animation_effect_toggle(state):
	GameState.use_animation_effect = state

var bind_mode = false

func bind_input(name, inst):
	bind_mode = true
	var event = yield(self, 'select_input')
	bind_mode = false
	InputMap.action_erase_events(name)
	InputMap.action_add_event(name, event)
	inst.get_node('Assignment').text = GameUi.get_input_name(event)
	GameUi.update_keybinds()

func _input(event):
	if bind_mode:
		# Let's ignore mouse movement because that'd be annoying
		if event is InputEventMouseMotion:
			return

		# Just in case...
		if event is InputEventAction:
			return

		# Skip esc too
		if event is InputEventKey and event.scancode == KEY_ESCAPE:
			return

		get_tree().set_input_as_handled()
		emit_signal('select_input', event)
