extends Node

const persistance = 4 #time after end of dialogue where text stays

var LINES = "res://Assets/Ressources/Lines.txt"
##class

var lines_dict:Dictionary




func create_dictionary():
	
	var f = FileAccess.open(LINES, FileAccess.READ)
	
	while not f.eof_reached():
		var line:String = f.get_line()
		
		if line.begins_with("//") or line=="": continue
		
		create_dict_line(line)
		
	f.close()


func create_dict_line(line):
	var elements:PackedStringArray = line.split(";", false)
	
	if elements.size() != 3:
		print("problem in Lines: line ", elements)
		return
	#assert (elements.size() == 3)
		
	
	var variations := elements[1].split("||", false)
	
	
	var paths:Array[String] = []
		
	for i in range(variations.size()):
		paths.append(
			"res://Assets/Audio/Lines" +
			elements[2].strip_edges() +
			"(" +
			str(i) +
			")" +
			".ogg"
		)
	lines_dict[elements[0].strip_edges()] = [
		variations,
		paths
	]

func get_line(line_name:String):
	return lines_dict[line_name]


############# dialogue system

class Dialogue_line:
	
	var text := ""
	
	var talker_name := ""
	
	var name_color:Color
	
	#higher priorities take the focus.
	var priority := 0
	
	var audio:AudioStreamOggVorbis
	
	var length:int = 5
	
	var player #Audiostreamplayer or audiostreamplayer3d
	
	func _init(line_name:String, talker_name:String, priority := 0, name_color := Color.CORNSILK, at = null):
		
		var data = DialogueManager.get_line(line_name)
		
		self.talker_name = talker_name
		self.priority = priority
		self.name_color = name_color
		
		var i:int = randi() % data[0].size()
		
		self.text = data[0][i]
		
		if ResourceLoader.exists(data[1][i]):
			self.audio = load(data[1][i])
			self.length = audio.get_length()
			
			if at==null:
				player = AudioStreamPlayer.new()
				DialogueManager.addchild(player)
			else:
				player = AudioStreamPlayer3D.new()
				at.addchild(player)
	
	func play():
		GameMaster.interface.get_node("DialogueWindow").play_dialogue(
			talker_name,
			name_color,
			text,
			length
			)
		play_audio()
	
	func play_audio():
		
		if audio != null:
			player.play()
	

#######


var dialogue_queue:Array[Dialogue_line] = []

var currently_playing:Dialogue_line

func _ready():
	create_dictionary()



func play_next_dialogue():
	
	
	currently_playing = null
	if dialogue_queue != []:
		currently_playing = dialogue_queue.pop_front()
		currently_playing.play()
		

func play_dialogue_now(line:Dialogue_line):
	
	currently_playing = line
	currently_playing.play()

func play_dialogue_audio_only(line:Dialogue_line):
	line.play_audio()

func queue_dialogue(line_name:String, talker_name:String, name_color := Color.CORNSILK, priority := 0, at = null):
	
	
	dialogue_queue.append(
		Dialogue_line.new(line_name, talker_name, priority, name_color, at)
	)
	if currently_playing == null: #triggers the dialogue if nothing's gonna come trigger it
		play_next_dialogue()

#plays the dialogue only if greater or equal priority. Always plays the audio.
func try_force_dialogue(line_name:String, talker_name:String, name_color := Color.CORNSILK, priority := 0, at = null):
	var d := Dialogue_line.new(line_name, talker_name, priority, name_color, at)
	if currently_playing:
		if currently_playing.priority < priority:
			play_dialogue_now(d)
		else:
			play_dialogue_audio_only(d)
	else:
		play_dialogue_now(d)

