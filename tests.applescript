tell application "Finder"
	set json_path to file "json.scpt" of folder of (path to me)
end
set json to load script (json_path as alias)


on assert_eq(a, b)
	if not a = b then
		set aq to quoted form of a as text
		set bq to quoted form of b as text
		error "values not equal:" & aq & " != " & bq
	end
end


assert_eq(json's jsonEncode("foo"), "\"foo\"")
log "ok"
