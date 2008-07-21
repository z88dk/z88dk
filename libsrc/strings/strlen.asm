; int __FASTCALL__ strlen(char *s)
; return length of s
; 12.2006 aralbrec

XLIB strlen

; enter: hl = char *s
; exit : hl = length
; uses : af, bc, hl

.strlen


IF FORrcmx000

	ld   d,h
	ld   e,l
	ld   hl,0    ; our counter
.strlen1
	ld   a,(de)
	and  a
	ret  z
	inc  de
	inc  hl
	jr   strlen1

ELSE

; A funky version that's quicker than the
; usual implementation for lengths > 1

	xor  a
	ld   c,a
	ld   b,a
	cpir
	ld   hl,$ffff
	sbc  hl,bc
	ret

ENDIF
