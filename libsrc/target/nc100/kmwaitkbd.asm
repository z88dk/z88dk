		
                SECTION code_clib
		PUBLIC	kmwaitkbd
		PUBLIC	_kmwaitkbd

.kmwaitkbd
._kmwaitkbd
		call 0xB80F
		ld h, b
		ld l, c
		ret





