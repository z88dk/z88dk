; recursive macro invocation
M1 macro
	M2
endm
M2 macro 
	M3
endm
M3 macro 
	M1
endm
M1
halt ; should come in the output
