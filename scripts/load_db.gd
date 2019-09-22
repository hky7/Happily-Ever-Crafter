extends Node

# SQLite module
const SQLite = preload("res://lib/gdsqlite.gdns");

func open_database(db : SQLite, path : String) -> bool:
	if (path.begins_with("res://")):
		# Open packed database
		var file = File.new();
		if (file.open(path, file.READ) != OK):
			return false;
		var size = file.get_len();
		var buffers = file.get_buffer(size);
		return db.open_buffered(path, buffers, size);
	
	# Open database normally
	return db.open(path);