; int __FASTCALL__ strlen(char *s)
; return length of s
; 12.2006 aralbrec

PUBLIC strlen

; enter: hl = char *s
; exit : hl = length, z flag set if 0 length
; uses : af, bc, hl

.strlen


IF FORrcmx000

	ld   b,h
	ld   c,l
	dec bc
	ld   hl,-1    ; our counter
	
.strlen1

        inc bc
        inc hl
	ld   a,(bc)
	and  a
	jp nz, strlen1
	
	ld a,h
	or l
	ret
	
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
