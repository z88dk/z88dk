
                SECTION code_clib
		PUBLIC	padoutparallel
		PUBLIC	_padoutparallel
; fast call
.padoutparallel
._padoutparallel
		ld a, l
		call 0xb860
		jr nc, nochar
		ld h, 0
		ld l, a
		ret
nochar:		ld hl, 0xffff
		ret

