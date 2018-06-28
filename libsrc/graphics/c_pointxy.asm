	INCLUDE	"graphics/grafix.inc"

        SECTION code_clib
	PUBLIC	c_pointxy

	EXTERN	pointxy

;
;	$Id: pointxy.asm,v 1.5 2016-04-13 21:09:09 dom Exp $
;

; ******************************************************************
;
; Check if pixel at	(x,y) coordinate is	set or not.
;
.c_pointxy
	ld	a,h
	cp	maxx / 4
	ret	nc
	ld	a,l
	cp	maxy / 4
	ret	nc

        sla     h
        sla     h
        sla     l
        sla     l
        ld      c,4
row_loop:
        push    hl
        ld      b,4
col_loop:
        push    bc
        push    hl
        call    pointxy
	jr	z,failed
        pop     hl
        inc     h
        pop     bc
        djnz    col_loop
        pop     hl
        inc     l
        dec     c
        jr      nz,row_loop
	; Success
	inc	c	; Non zero
	ret

; Fz is set
failed:
	pop	hl
	pop	bc
	pop	hl
	ret


