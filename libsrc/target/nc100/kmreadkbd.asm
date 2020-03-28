                SECTION code_clib		
		PUBLIC	kmreadkbd
		PUBLIC	_kmreadkbd

.kmreadkbd
._kmreadkbd
		call 0xB806
		jr c, kmread_1
		ld bc, 0xffff
kmread_1:
		ld h, b
		ld l, c
		ret



