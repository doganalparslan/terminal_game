extends Node

var dtag := "command processor : "
var comp := "computer: "

var incoming_input: Array
var response_text: String
var response_time := 0
var placeholder_text: String
var placeholder_time := 0

var word: String

var no_match: bool = false

var outputs: Dictionary = {   #might change to an inner class
		"Response Text": response_text, 
		"Response Time": response_time
		 , 
		"Placeholder Text": placeholder_text, 
		"Placeholder Time": placeholder_time
	}



func process_command(input: String) -> Dictionary:
	#Global.save_to_file(input)
	incoming_input = input.split(" ", false)
	
	for i in incoming_input.size(): #WHY THIS DOESN'T WORK?
		incoming_input[i] = incoming_input[i].to_lower()
		
	print(dtag + str(incoming_input) + " words have been received")

	no_match = false

	match incoming_input:
		[".print", "audio"]:
			set_output(0, comp + "audio_level: " + str(Global.audio_level) + " Bus_level" + str(AudioServer.get_bus_volume_linear(0)))
		[".save"]:
			set_output(0, comp + "Game saved")
		[".print", "save"]:
			set_output(0, comp + Global.saver)
			print(dtag + Global.saver)
		#[".delete", "save"]:
			#Global.saver = ""
			#Global.save_to_file(Global.saver)
			#set_output(0, comp + "all saves have been deleted")
		[".longtexttest"]:
			set_output(0, comp + "This is a really long text string; which was specifically put here to see whether longer texts/strings work alright or not. If everything is okay and under control, you should be seeing this text, reading it till this point while hearing the machine beeping in between 3-5 seconds")
		[".change", "interface", "color"]:
			set_output(0, comp + "Available colors are; green, red, blue, yellow. To change interface color, type; .change interface color 'desired color'")
		[".change", "interface", "color", var color_pf]: 
			set_output(0, comp + "interface color has been changed")
			Global.font_theme = load("res://themes/" + color_pf + "_font.tres")
			get_parent().set_theme(Global.font_theme)
			Global.font_color = color_pf
			Global.change_font_size(Global.font_size)
		[".settings"]:
			set_output(0, comp + "Avaliable Commands | .change audio | .resolution presets | .change window mode | .change interface color | .advanced commands | .kill terminal")
		["help"]:
			set_output(0, comp + "Avaliable Commands | .change audio | .resolution presets | .change window mode | .change interface color | .advanced commands | .kill terminal")
		[".change", "audio"]:
			set_output(0, comp + "to set audio, enter; .change audio 'desired audio level' ")
		[".change", "audio", var audio_lv]:
			Global.change_audio(clampf(audio_lv.to_float(), 0, 100))
			set_output(0, "audio level has changed to " + audio_lv)
		[".advanced" , "commands"]:
			set_output(0, comp + "Advanced Commands: .res , .char_size, .set_window , .longtexttest")
		[".res"]:
			set_output(0, comp + "to change resolution, type '.res' followed by the '(width)x(height)' of the desired resolution (without spaces)")
		[".resolution", "presets"]:
			set_output(0, comp + "type one: .res(720)(480) , .res(1080)(720) , .res(1920)(1080)")
		[".char_size"]:
			set_output(0, comp + "to set character size, type: '.char_size (x)' changing x as the amount preferred")
		[".change" , "window" , "mode"]:
			if DisplayServer.window_get_mode() == 0:
				Global.set_fullscreen("fullscreen")
			elif DisplayServer.window_get_mode() == 3:
				Global.set_fullscreen("windowed")
			set_output(0, comp + "your window mode has changed")
		[".set_window"]:
			set_output(0,comp +  "to change window mode, type one: .windowed or .fullscreen")
		[".windowed"]:
			Global.set_fullscreen("windowed")
			set_output(0, comp +  "mode has been set to window")
		[".fullscreen"]:
			Global.set_fullscreen("fullscreen")
			set_output(0, comp + "mode has been set to fullscreen")
		[".kill", "terminal"]:
			set_output(0, comp + "system shutting down")
		_: #this works as else/ no input was matching
			if incoming_input.is_empty():
				set_output()
			else: #TO BE ADDED-CHECK IF IT CORRESPONDS TO A MESSAGE
				if incoming_input.has(".res"):
					var res_xy: Array
					if incoming_input.any(is_number) == false:
						print(dtag + str(input.to_int()))
						res_xy.append(str(DisplayServer.window_get_size().x))
						res_xy.append(str(DisplayServer.window_get_size().y))
					else:
						for i: String in incoming_input:
							if i.to_int() != 0:
								var if_x: Array = i.split("x", false)
								if if_x.size() > 1:
									res_xy.append_array(i.split("x", false))
								else:
									res_xy.append(i)
					Global.change_resolution(Vector2(clampi(res_xy[0].to_int(), 300, 8000), clampi(res_xy[1].to_int(), 300, 8000)))
					set_output(0, "resolution has changed to: " + str(res_xy[0]) + "x" + str(res_xy[1]))
				
				elif incoming_input.has(".char_size"):
					for i: String in incoming_input:
						if i.to_int() != 0:
							Global.change_font_size(i.to_int())
							set_output(0, "character size has changed to: " + str(i))
				else:
					print(dtag + "no word matched a system command") 
					no_match = true
					set_output(0, "")
	
	return outputs



func set_output(await_time := 0.0, output := ""):
	outputs["Response Text"] = output
	outputs["Response Time"] = await_time



func set_placeholder(await_time := 0.0, placeholder := "") -> void:
	outputs["Placeholder Text"] = placeholder
	outputs["Placeholder Time"] = await_time



func is_number(is_it: String):
	return is_it.to_int() > 0
