		SECTION	code_clib
		PUBLIC	__fdatestamp
		PUBLIC	_fdatestamp

; Fastcall
.__fdatestamp
._fdatestamp
		call 0xB8C9
		ld hl, 0
		ret c
		dec hl
		ret

