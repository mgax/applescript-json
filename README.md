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
