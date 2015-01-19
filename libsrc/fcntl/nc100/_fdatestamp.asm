		PUBLIC	_fdatestamp

; Fastcall
._fdatestamp
		call 0xB8C9
		ld hl, 0
		ret c
		dec hl
		ret

