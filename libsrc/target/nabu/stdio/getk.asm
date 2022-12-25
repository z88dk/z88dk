

SECTION code_clib


EXTERN getk
EXTERN _getk

INCLUDE "target/nabu/def/nabu.def"

getk:
_getk:
	ld	hl,0
	in	a,(IO_KEYBOARD_STATUS)
	and	0x02
	ret	z
	in	a,(IO_KEYBOARD)
	; Keycodes 0x90 -> 0x95 mean something and are ignored
	cp	0x90
	jr	c,not_bad
	cp	0x95
	ret	nc
not_bad:
	ld	l,a
	ld	h,0
	ret

