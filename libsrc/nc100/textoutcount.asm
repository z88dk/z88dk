		PUBLIC textoutcount
; fastcall
.textoutcount
		call 0xB821
		ld l, b
		ld h, 0
		ret

