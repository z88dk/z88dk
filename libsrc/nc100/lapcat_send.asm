		PUBLIC	lapcat_send

; fast call
.lapcat_send
		ld a, l
		call 0xb8db
		ld hl, 0
		ret c
		dec hl
		ret





