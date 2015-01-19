		PUBLIC txtgetwindow

; fastcall
.txtgetwindow	push hl
		call 0xB830
		pop ix
		ld (ix), h
		ld (ix + 1), l
		ld (ix + 2), d
		ld (ix + 3), e
		ld (ix + 4), 0
		ret c
		ld (ix + 4), 1
		ret


