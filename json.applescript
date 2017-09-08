on encode(value)
	set type to class of value
	if type = integer or type = boolean
		return value as text
	else if type = text
		return encodeString(value)
	else if type = list
		return encodeList(value)
	else if type = script
		return value's toJson()
	else
		error "Unknown type " & type
	end
end


on encodeList(value_list)
	set out_list to {}
	repeat with value in value_list
		copy encode(value) to end of out_list
	end
	return "[" & join(out_list, ", ") & "]"
end


on encodeString(value)
	set rv to ""
	set codepoints to id of value

	if (class of codepoints) is not list
		set codepoints to {codepoints}
	end

	repeat with codepoint in codepoints
		set codepoint to codepoint as integer
		if codepoint = 34
			set quoted_ch to "\\\""
		else if codepoint = 92 then
			set quoted_ch to "\\\\"
		else if codepoint >= 32 and codepoint < 127
			set quoted_ch to character id codepoint
		else
			set quoted_ch to "\\u" & hex4(codepoint)
		end
		set rv to rv & quoted_ch
	end
	return "\"" & rv & "\""
end


on join(value_list, delimiter)
	set original_delimiter to AppleScript's text item delimiters
	set AppleScript's text item delimiters to delimiter
	set rv to value_list as text
	set AppleScript's text item delimiters to original_delimiter
	return rv
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


on createDictWith(item_pairs)
	set item_list to {}

	script Dict
		on setkv(key, value)
			copy {key, value} to end of item_list
		end

		on toJson()
			set item_strings to {}
			repeat with kv in item_list
				set key_str to encodeString(item 1 of kv)
				set value_str to encode(item 2 of kv)
				copy key_str & ": " & value_str to end of item_strings
			end
			return "{" & join(item_strings, ", ") & "}"
		end
	end

	repeat with pair in item_pairs
		Dict's setkv(item 1 of pair, item 2 of pair)
	end

	return Dict
end


on createDict()
	return createDictWith({})
end
