		
                SECTION code_clib
		PUBLIC	padreadyparallel
		PUBLIC	_padreadyparallel

; fastcall
.padreadyparallel
._padreadyparallel
		call 0xb866
		ld hl, 0
		ret nc
		inc hl
		ret
