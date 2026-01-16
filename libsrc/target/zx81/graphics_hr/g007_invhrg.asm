;--------------------------------------------------------------
; G007 style Graphics
; for the ZX81
;--------------------------------------------------------------
;
;       We cant invert the screen output on the G007
;       This is a normal graphics memory inversion to
;       produce the BEL effect in the ANSI-VT mode 
;
;       Stefano - 2025
;
;
;	$Id: g007_invhrg.asm $
;

    SECTION code_clib
    PUBLIC  invhrg
    PUBLIC  _invhrg

    EXTERN  base_graphics

invhrg:
_invhrg:
    ld      hl, (base_graphics)

    ld		de,9
	add		hl,de
	
invhrg2:
	ld		bc,34*24*8
invloop:
    ld      a, (hl)
    xor     255
    ld      (hl), a
	inc hl
	dec bc

	ld		a,b
	or		c
    jr		nz,invloop
    ret

; Alternative hack for BEL in the ANSI-VT mode,
; it shows only 2 black bars on the screen sides.
; to avoid the 'graphics fill' effect.

;    ld      hl, (base_graphics)
;    ld		de,8
;	add		hl,de
;	ld		de,33
;invhrg2:
;	ld		b,192
;invloop:
;    ld      a, (hl)
;    xor     255
;    ld      (hl), a
;	inc hl
;    ld      a, (hl)
;    xor     255
;    ld      (hl), a
;    add     hl,de
;    djnz    invloop
;	ret

