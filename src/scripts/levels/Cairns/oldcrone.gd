extends StaticBody2D

var solved = false

func _interact(player):
	if not solved and not player.has_item('spectacles'):
		get_node('/root/GameUi').start_dialogue([
			{
				'portrait': 'OldCrone',
				'name': 'Old Crone',
				'body': "Hello little one, you haven't seen a pair of spectacles around here, have you?"
			},
			{
				'body': "I was in a trance, meditating on the solution, when a spirit took over my body. When I came to, I was crouched in that corner over there, and my face was wet with tears...I suddenly knew the right order to activate the stones, but now I can't find my glasses."
			},
			{
				'body': "I'll tell you what--I'll make you a deal: If you can find them for me, I'll tell you the correct order."
			}
		])
	elif not solved:
		get_node('/root/GameUi').start_dialogue([
			{
				'portrait': 'OldCrone',
				'name': 'Old Crone',
				'body': "They were over there? Huh...I could have sworn I looked there thoroughly...how strange. Well, you've fulfilled your end of the deal, so now for my part: The correct order is: 'I, S, M, H, B'" }])
		player.rem_item('spectacles')
		solved = true
	else:
		get_node('/root/GameUi').start_dialogue([
			{
				'portrait': 'OldCrone',
				'name': 'Old Crone',
				'body': "Thank you for helped out an old lady. In case you forgot, the correct order is: 'I, S, M, H, B'"
			}
		])

func _ready():
	pass 

