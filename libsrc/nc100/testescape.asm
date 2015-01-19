		PUBLIC	testescape

.testescape
		call 0xB815
		ld hl, 1
		ret nc
		jr z, noesc
		dec hl
noesc:		dec hl
		ret



