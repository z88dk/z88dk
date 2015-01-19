
		PUBLIC	padinserial

.padinserial
		call 0xb85d
		jr nc, nochar
		ld h, 0
		ld l, a
		ret
nochar:		ld hl, 0xffff
		ret

