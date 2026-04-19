; macro parameters without parens
#macro M1 p1, p2
	ld a, p1
	ld b, p2
#endm
.label1 M1 1, 2
#macro M2 p1, p2
	ld c, p1
	ld d, p2
#endm
.label2 M2 3, 4
#macro M3 p1, p2, p3, p4
	M1 p1, p2
	M2 p3, p4
#endm
.label3 M3 1, 2, 3, 4
#macro M4 p1, p2, p3, p4
	M3 p1, p2, p3, p4
#endm
.label4 M4 1, 2, 3, 4
