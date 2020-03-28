		
                SECTION code_clib
		PUBLIC	padreadyserial
		PUBLIC	_padreadyserial

; fastcall
.padreadyserial
._padreadyserial
		call 0xb869
		ld hl, 0
		ret nc
		inc hl
		ret
