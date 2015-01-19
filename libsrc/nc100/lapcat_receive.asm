		PUBLIC	lapcat_receive

.lapcat_receive
		call 0xb8d5
		ld h, 0
		ld l, a
		ret c
		ld hl, 0xffff
		ret





