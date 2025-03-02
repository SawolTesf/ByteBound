extends Node

# add this to the gitignore
var _log_file_path : String = "user://Logs"

## Prints a messages to the approprate logfile.
##If show_stack is true also print the stack out
func log(message: String, show_stack : bool) -> void:
	# pull info from the stack
	var data = _get_stack_data(2)
	var source = data.get("source").get_file()
	var function = data.get("function")
	
	# Get the current time
	var date = Time.get_date_string_from_system()
	var time = Time.get_time_string_from_system()
	
	# define the file to save the log to
	var file_path = _log_file_path + "/" + source.get_slice(".", 0).capitalize() + "/" + source.get_slice(".", 0) + ".log"

	# Print message to the console of the logs location 
	print("LOG: info written to %s" % file_path )

	# Write the logs to file
	var content : String = "-".repeat(70) + "\nLOG: Time: %s-%s, function: %s\n%s\n" % [date, time, function, message]
	write_to_file(file_path, content)
	if show_stack:
		write_to_file(file_path, stack_to_string())


## Used to log a debug message to the console
## Contains some infromation about the function debug was called from
## Info includes the script name, and function name.
func debug(caller : Object, message : String, show_stack: bool) -> void:
	var data = _get_stack_data(2)
	var source = data.get("source").get_file()
	var function = data.get("function")
	var calling_class = _get_calling_class(caller)

	print("-".repeat(70))
	print("DEBUG: class: %s  source: %s  function: %s()\n%s" % [calling_class, source, function, message])
	if show_stack:
		print(stack_to_string())


## Returns a single element of the stack Dictionary 
func _get_stack_data(i : int) -> Dictionary:
	var stack : Array = get_stack()
	if i < 0 or i > stack.size():
		return {"source": "NA", "function" : "NA", "line" : "NA"}
	var data : Dictionary = stack[i]
	return data


func _get_calling_class(object : Object) -> String:
	var script = object.get_script()
	if script:
		var c_name = script.get_global_name()
		if c_name != "":
			return c_name
		
	return object.get_class()
			

## Returns the stack as a string
func stack_to_string() -> String:
	var stack: Array = get_stack()
	var source : String
	var function : String
	var line : int
	var result : String = ""
	
	for i in range(stack.size()):
		line = stack[i].get("line")
		source = stack[i].get("source")
		function = stack[i].get("function")
		result = result + "%s: source: %s , function: %s, line: %d\n" % [i, source, function, line]

	return result


func write_to_file(file_path: String, content: String) -> void:
	# Ensure the directory exists
	var dir = file_path.get_base_dir()
	if not DirAccess.dir_exists_absolute(dir):
		DirAccess.make_dir_recursive_absolute(dir)
	
	# Try to open the file
	var file = FileAccess.open(file_path, FileAccess.READ_WRITE)
	if file:
		file.seek_end()
		file.store_string(content)
		file.close()
		print("Successfully wrote to file: %s" % file_path)
	else:
		print("Failed to open file: %s" % file_path)
		print("Error: %s" % FileAccess.get_open_error())
