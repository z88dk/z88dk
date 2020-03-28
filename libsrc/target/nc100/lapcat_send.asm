		
                SECTION code_clib
		PUBLIC	lapcat_send
		PUBLIC	_lapcat_send

; fast call
.lapcat_send
._lapcat_send
		ld a, l
		call 0xb8db
		ld hl, 0
		ret c
		dec hl
		ret





