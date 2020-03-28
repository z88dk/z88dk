                SECTION code_clib	
		PUBLIC	padoutserial
		PUBLIC	_padoutserial

; fastcall
.padoutserial
._padoutserial
		ld a, l
		call 0xb863
		ld hl, 0
		ret c
		dec hl
		ret
