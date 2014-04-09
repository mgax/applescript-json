## AppleScript JSON encoder

AppleScript lacks a native way to generate JSON, which makes getting
data out of scripts difficult. This script provides a basic JSON
encoding capability, to serialize strings, integers, lists and
dictionaries.

### Installation

Build the `json.scpt` file by running `make`, copy it next to your
script, and import it with the following code:

```applescript
tell application "Finder"
    set json_path to file "json.scpt" of folder of (path to me)
end
set json to load script (json_path as alias)
```

Alternatively, just copy/paste the contens of `json.applescript` into
your own script, and use it straigt away.

### Usage

To encode strings, numbers and lists:

```applescript
json's encode("hellø world")
-- "hell\u00f8 world"

json's encode(13)
-- 13

json's encode({1, "2", {3, 4}})
-- [1, "2", [3, 4]]
```

Dictionaries are supported via a wrapper object:

```applescript
set my_dict to json's createDict()
my_dict's setkv("hello", {"world", 13})
json's encode(my_dict)
-- {"hello": ["world", 13]}

set my_dict_2 to json's createDictWith({ {"foo", "bar"}, {"baz", 22} })
json's encode(my_dict_2)
-- {"foo": "bar", "baz": 22}
```

And also natively (which gives a small performance penalty):
```applescript
json's encode({glossary:¬
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
			})
```

Decoding is also available (dictionaries with keys which contain spaces are not supported):
```applescript
set dict to {foo:"bar"}
json's decode(json's encode(dict)) -- {foo: "bar"}
```
