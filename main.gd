#extends Node
#
#var rescued_prompt
#
	#
#func _ready():
	#var test_scene = preload("res://test.tscn").instantiate()
	#add_child(test_scene)
	#rescued_prompt = test_scene.get_node("RescuedPrompt")
	#if rescued_prompt:
		#rescued_prompt.connect("AnimalRescued", self, "_on_animal_rescued")
	### 获取 test.tscn 中的 RescuedPrompt 节点
	##rescued_prompt = test_scene_instance.get_node("RescuedPrompt")
##
	### 连接 RescuedPrompt 发射的信号到 OnAnimalRescued 方法
	##rescued_prompt.connect("AnimalRescued", self, "_on_animal_rescued")
##
### 回调方法，当信号触发时调用
#func _on_animal_rescued():
	#print("The animal has been rescued from the prompt!")
