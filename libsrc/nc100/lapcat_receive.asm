		
                SECTION code_clib
		PUBLIC	lapcat_receive
		PUBLIC	_lapcat_receive

.lapcat_receive
._lapcat_receive
		call 0xb8d5
		ld h, 0
		ld l, a
		ret c
		ld hl, 0xffff
		ret





