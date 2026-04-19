rept -1
	not expanded
endr
rept 0
	not expanded
endr
rept 12345/12345
	ld a, 1
endr
rept 2
	ld a, 2
endr
rept 2
	rept 2
		ld a, 4
	endr
endr
