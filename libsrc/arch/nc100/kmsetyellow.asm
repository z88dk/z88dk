		
                SECTION code_clib
		PUBLIC	kmsetyellow
		PUBLIC	_kmsetyellow

; fastcall
.kmsetyellow
._kmsetyellow
		ld b, h
		ld c, l
		jp 0xb8d5




