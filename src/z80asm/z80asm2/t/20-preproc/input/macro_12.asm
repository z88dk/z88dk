; recursive macro invocation
#macro M1 
	M2
#endm
#macro M2 
	M3
#endm
#macro M3 
	M1
#endm
M1
halt ; should come in the output
