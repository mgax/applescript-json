json.scpt: json.applescript
	osacompile -o json.scpt json.applescript

test: json.scpt
	osascript tests.applescript

.PHONY: test
