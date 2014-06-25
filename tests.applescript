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


assert_eq(json's hex4(0), "0000")
assert_eq(json's hex4(1), "0001")
assert_eq(json's hex4(11), "000b")
assert_eq(json's hex4(2*16), "0020")
assert_eq(json's hex4(65534), "fffe")
assert_eq(json's hex4(65535), "ffff")
assert_eq(json's hex4(65536), "0000")
assert_eq(json's hex4(65537), "0001")

assert_eq(json's encode(1), "1")
assert_eq(json's encode(0), "0")

assert_eq(json's encode(true), "true")
assert_eq(json's encode(false), "false")

assert_eq(json's encode("foo"), "\"foo\"")
assert_eq(json's encode(""), "\"\"")
assert_eq(json's encode("\n"), "\"\\u000a\"")
assert_eq(json's encode("ș"), "\"\\u0219\"")
assert_eq(json's encode("\"bar\""), "\"\\\"bar\\\"\"")
assert_eq(json's encode("\\"), "\"\\\\\"")

assert_eq(json's encode({1, 2, 3}), "[1, 2, 3]")

assert_eq(json's encode(json's createDict()), "{}")

set dict to json's createDictWith({{"foo", "bar"}})
assert_eq(json's encode(dict), "{\"foo\": \"bar\"}")

set dict2 to json's createDictWith({{"a", 13}, {"b", {2, "other", dict}}})
assert_eq(json's encode(dict2), "{\"a\": 13, \"b\": [2, \"other\", {\"foo\": \"bar\"}]}")

log "ok"
