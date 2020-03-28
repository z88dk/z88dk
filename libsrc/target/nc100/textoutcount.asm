

                SECTION code_clib
		PUBLIC textoutcount
		PUBLIC _textoutcount
; fastcall
.textoutcount
._textoutcount
		call 0xB821
		ld l, b
		ld h, 0
		ret

