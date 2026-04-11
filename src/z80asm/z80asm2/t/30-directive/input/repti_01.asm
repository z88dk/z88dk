repti ; no identifier
endr
repti 27 ; no identifier
endr
repti v ; no comma
endr
repti v, ; no arguments
endr
repti v, (2+3
	ld a, v
endr
repti v, 2+3)
	ld a, v
endr
repti v, a, b, c ; no endr
