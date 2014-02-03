on encode(value)
	set type to class of value
	if type = text
		return encodeString(value)
	else
		error "Unknown type " & type
	end
end


on encodeString(value)
	set rv to ""
	repeat with ch in value
		if id of ch >= 32 and id of ch < 127
			set quoted_ch to ch
		else
			set quoted_ch to "\\u" & hex4(id of ch)
		end
		set rv to rv & quoted_ch
	end
	return "\"" & rv & "\""
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
