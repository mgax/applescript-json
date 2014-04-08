json.scpt: json.applescript
	osacompile -o json.scpt json.applescript

test: json.scpt
	osacompile -o ASUnit/ASUnit.scpt -x ASUnit/ASUnit.applescript
	osascript tests.applescript
