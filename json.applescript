on jsonEncode(value)
	set type to class of value
	if type = text
		return jsonEncodeString(value)
	else
		error "Unknown type " & type
	end
end jsonEncode


on jsonEncodeString(value)
	return "\"" & value & "\""
end
