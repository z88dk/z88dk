

SECTION code_clib


PUBLIC getk
PUBLIC _getk
EXTERN __nabu_lastk

INCLUDE "target/nabu/def/nabu.def"

getk:
_getk:
        ld      hl,__nabu_lastk
        ld      e,(hl)
        ld      (hl),0
        ld      d,0
        ex      de,hl
        ret

IF 0
	ld	hl,0
	in	a,(IO_KEYBOARD_STATUS)
	and	0x02
	ret	z
	in	a,(IO_KEYBOARD)
not_bad:
	ld	l,a
	ld	h,0
	ret

ENDIF
