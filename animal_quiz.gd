extends AcceptDialog

# quiz pool
const QUIZ_POOL = [
	{
		#https://www.wildernesscollege.com/animal-tracks-field-guide-update.html
		"question": "These tracks belong to which species?",
		"options" : ["Snake", "Cat", "Lizard", "Dog"],
		"correct" : 2,
		"info"    : "These are the tracks of a Gila monster(Lizard). They show short, \nthick toe marks and a visible tail drag through\n the sand. Gila monsters are slow-moving, venomous lizards\n native to the deserts of the southwestern United States.",
		"texture" : preload("res://Images/gm_footprint.png")
	},
	{
		"question": "Exendin-4, a compound isolated from Gila monster venom in 1992,\nis now commonly used to treat which disease?",
		"options" : ["Heart disease", "Diabetes", "Epilepsy", "High blood pressure"],
		"correct" : 1,
		"info"    : "Exendin-4 is the basis for the drug exenatide, which helps regulate \nblood sugar levels in people with type 2 diabetes.",
		"texture" : preload("res://creatures/gila.png")
	},
	# to add more
]

# index
var _idx = 0

# assign vars
#@onready var img       = $NinePatchRect
@onready var lbl_q     = $MarginContainer/VBoxContainer/LabelQuestion
@onready var choice_ct = $MarginContainer/VBoxContainer/choiceContainer
@onready var lbl_fb    = $MarginContainer/VBoxContainer/LabelFeedback
#@onready var img: NinePatchRect = $NinePatchRect
@onready var img: NinePatchRect = $MarginContainer/VBoxContainer/NinePatchRect

#func _ready():
	#show_quiz()

func show_quiz():
	print("▶ AnimalQuiz.show_quiz() 被调用，当前题目索引：", _idx)
	_show_next_quiz()

#looping the function
func _show_next_quiz():
	var data = QUIZ_POOL[_idx]
	_idx = (_idx + 1) % QUIZ_POOL.size()
	
	# fill in data from pool
	img.texture    = data.texture
	lbl_q.text     = data.question
	lbl_fb.visible = false

	# sign choice for each button, call _on_option_pressed when choice is made

	for i in range(choice_ct.get_child_count()):
		var btn = choice_ct.get_child(i) as Button

		#disconnect _on_option_pressed
		for conn in btn.pressed.get_connections():
			if conn.callable.get_method() == "_on_option_pressed":
				btn.pressed.disconnect(conn.callable)

		if i < data.options.size():
			btn.visible  = true
			btn.disabled = false
			btn.text     = data.options[i]

			var callback = Callable(self, "_on_option_pressed").bind(i, data.correct, data.info)
			btn.pressed.connect(callback)
		else:
			btn.visible = false

#	as name
	popup_centered()


func _on_option_pressed(chosen_idx: int, correct_idx: int, info: String):
	# buttons are disabled after pressed
	for btn in choice_ct.get_children():
		btn.disabled = true

	# feedback
	if chosen_idx == correct_idx:
		lbl_fb.text = "You are right!!\n\n" + info
	else:
		lbl_fb.text = "Oops~\n\n" + info

	lbl_fb.visible = true
