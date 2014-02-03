tell application "Finder"
	set json_path to file "json.scpt" of folder of (path to me)
end
set json to load script (json_path as alias)


tell json
	jsonEncode("foo as json")
	(*error "you fail"*)
end
