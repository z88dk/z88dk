local ; outside macro
X local; outside macro
macro M1
	local ; no variable
endm
macro M2
	label local 12 ; extra input
endm
