local ; outside macro
local X; outside macro
macro M1
	local ; no variable
endm
macro M2
	local 12 ; no variable
endm
macro M3
	local label, ; missing variable
endm
macro M4
	local l1,l2 extra ; extra input
endm
macro M5
	local l1,l1 ; duplicate parameter
endm
