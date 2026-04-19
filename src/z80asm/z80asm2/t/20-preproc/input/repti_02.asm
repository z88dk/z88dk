repti v, a
	ld v, 0
endr
repti v, a, b, (c,d)
	ld v, 0
endr
repti src, a, b
	repti dst, x, y
		ld src, dst
	endr
endr
