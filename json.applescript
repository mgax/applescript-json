on jsonEncode(value)
	set type to class of value
	if type = text
		return jsonEncodeString(value)
	else
		error "Unknown type " & type
	end
end jsonEncode


on jsonEncodeString(value)
end


on hex4(n)
	set digit_list to "0123456789abcdef"
	set rv to ""
	repeat until length of rv = 4
		set digit to (n mod 16)
		set n to (n - digit) / 16 as integer
		set rv to (character (1+digit) of digit_list) & rv
	end
	return rv
end
