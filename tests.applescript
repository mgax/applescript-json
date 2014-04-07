tell application "Finder"
	set json_path to file "json.scpt" of folder of (path to me)
end tell
set json to load script (json_path as alias)


on assert_eq(a, b)
	if not a = b then
		error
	end if
end assert_eq


assert_eq(json's hex4(0), "0000")
assert_eq(json's hex4(1), "0001")
assert_eq(json's hex4(11), "000b")
assert_eq(json's hex4(2 * 16), "0020")
assert_eq(json's hex4(65534), "fffe")
assert_eq(json's hex4(65535), "ffff")
assert_eq(json's hex4(65536), "0000")
assert_eq(json's hex4(65537), "0001")

assert_eq(json's encode(1), "1")
assert_eq(json's encode(0), "0")

assert_eq(json's encode("foo"), "\"foo\"")
assert_eq(json's encode(""), "\"\"")
assert_eq(json's encode("
"), "\"\\u000a\"")
assert_eq(json's encode("ș"), "\"\\u0219\"")

assert_eq(json's encode({1, 2, 3}), "[1, 2, 3]")

assert_eq(json's encode(json's createDict()), "{}")

set dict to {foo:"bar", test:null}
assert_eq(json's encode(dict), "{\"test\": null, \"foo\": \"bar\"}")
assert_eq(json's decode(json's encode(dict)), dict)

set dict2 to {a:13, b:{2, "other", dict}}
assert_eq(json's encode(dict2), "{\"a\": 13, \"b\": [2, \"other\", {\"test\": null, \"foo\": \"bar\"}]}")
assert_eq(json's decode(json's encode(dict2)), dict2)


set dict5 to ¬
	{glossary:¬
		{GlossDiv:¬
			{GlossList:¬
				{GlossEntry:¬
					{GlossDef:¬
						{GlossSeeAlso:¬
							["GML", "XML"], para:"A meta-markup language, used to create markup languages such as DocBook."} ¬
							, GlossSee:"markup", Acronym:"SGML", GlossTerm:"Standard Generalized Markup Language", Abbrev:"ISO 8879:1986", SortAs:"SGML", id:¬
						"SGML"} ¬
						}, title:"S"} ¬
				, title:"example glossary"} ¬
			}
assert_eq(json's decode(json's encode(dict5), true, true), dict5)


log "ok"