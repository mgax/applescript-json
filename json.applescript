on encode(value)
	set type to class of value
	if type = integer then
		return value as text
	else if type = text then
		return encodeString(value)
	else if type = list then
		return encodeList(value)
	else if type = script then
		return value's toJson()
	else if type = record then
		return encodeRecord(value)
	else
		error "Unknown type " & type
	end if
end encode

on encodeList(value_list)
	set out_list to {}
	repeat with value in value_list
		copy encode(value) to end of out_list
	end repeat
	return "[" & join(out_list, ", ") & "]"
end encodeList


on encodeString(value)
	set rv to ""
	repeat with ch in value
		if id of ch ³ 32 and id of ch < 127 then
			set quoted_ch to ch
		else
			set quoted_ch to "\\u" & hex4(id of ch)
		end if
		set rv to rv & quoted_ch
	end repeat
	return "\"" & rv & "\""
end encodeString


on join(value_list, delimiter)
	set original_delimiter to AppleScript's text item delimiters
	set AppleScript's text item delimiters to delimiter
	set rv to value_list as text
	set AppleScript's text item delimiters to original_delimiter
	return rv
end join


on hex4(n)
	set digit_list to "0123456789abcdef"
	set rv to ""
	repeat until length of rv = 4
		set digit to (n mod 16)
		set n to (n - digit) / 16 as integer
		set rv to (character (1 + digit) of digit_list) & rv
	end repeat
	return rv
end hex4


on createDictWith(item_pairs)
	set item_list to {}
	
	script Dict
		on setkv(key, value)
			copy {key, value} to end of item_list
		end setkv
		
		on toJson()
			set item_strings to {}
			repeat with kv in item_list
				set key_str to encodeString(item 1 of kv)
				set value_str to encode(item 2 of kv)
				copy key_str & ": " & value_str to end of item_strings
			end repeat
			return "{" & join(item_strings, ", ") & "}"
		end toJson
	end script
	
	repeat with pair in item_pairs
		Dict's setkv(item 1 of pair, item 2 of pair)
	end repeat
	
	return Dict
end createDictWith

on createDict()
	return createDictWith({})
end createDict

on split(aString, aDelimiters)
	set oldDelimiters to AppleScript's text item delimiters
	set AppleScript's text item delimiters to aDelimiters
	set theArray to every text item of aString
	set AppleScript's text item delimiters to aDelimiters
	return theArray
end split

on recordToString(aRecord)
	set oldClipboard to the clipboard
	set the clipboard to aRecord
	set str to (do shell script "osascript -e 'the clipboard as record'")
	set the clipboard to oldClipboard
	return str
end recordToString

on getValueFromKey(aRecord, aKey)
	set s to "on run {aRecord}" & return
	set s to s & "get " & aKey & " of aRecord" & return
	set s to s & "end"
	return (run script s with parameters {aRecord})
end getValueFromKey

on recordKeys(value_record)
	set str to recordToString(value_record)
	set tokens to split(str, {":", ","})
	set possibleKeys to {}
	repeat with token in tokens
		set possibleKey to trim(change_case(token, "lower"))
		if possibleKey is not in possibleKeys then
			set end of possibleKeys to possibleKey
		end if
	end repeat
	set recordKeyList to {}
	repeat with possibleKey in possibleKeys
		try
			getValueFromKey(value_record, possibleKey)
			--If not found we do not reach this
			set end of recordKeyList to ("" & possibleKey)
		end try
	end repeat
	if (count recordKeyList) is not (count value_record) then
		error "recordKeys could not successfully recover all keys in the given record"
	end if
	return recordKeyList
end recordKeys

on encodeRecord(value_record)
	set keys to recordKeys(value_record)
	set dictionary to createDict()
	repeat with recordKey in keys
		dictionary's setkv(recordKey, getValueFromKey(value_record, recordKey))
	end repeat
	return encode(dictionary)
end encodeRecord

on trim(someText)
	repeat until someText does not start with " "
		set someText to text 2 thru -1 of someText
	end repeat
	
	repeat until someText does not end with " "
		set someText to text 1 thru -2 of someText
	end repeat
	
	return someText
end trim
property lower_alphabet : "abcdefghijklmnopqrstuvwxyz"
property upper_alphabet : "ABCDEFGHIJKLMNOPQRSTUVWXYZ"
property white_space : {space, tab, return, ASCII character 10, ASCII character 13}
on change_case(this_text, this_case)
	set new_text to ""
	if this_case is not in {"UPPER", "lower", "Title", "Sentence"} then
		return "Error: Case must be UPPER, lower, Title or Sentence"
	end if
	if this_case is "lower" then
		set use_capital to false
	else
		set use_capital to true
	end if
	repeat with this_char in this_text
		set x to offset of this_char in lower_alphabet
		if x is not 0 then
			if use_capital then
				set new_text to new_text & character x of upper_alphabet as string
				if this_case is not "UPPER" then
					set use_capital to false
				end if
			else
				set new_text to new_text & character x of lower_alphabet as string
			end if
		else
			if this_case is "Title" and this_char is in white_space then
				set use_capital to true
			end if
			set new_text to new_text & this_char as string
		end if
	end repeat
	return new_text
end change_case
