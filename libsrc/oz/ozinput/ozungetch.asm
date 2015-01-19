;
;	Sharp OZ family functions
;
;	ported from the OZ-7xx SDK by by Alexander R. Pruss
;	by Stefano Bodrato - Oct. 2003
;
;
;	int ozungetch(int key-char);
;	puts a character back in the keyboard buffer
;
; ------
; $Id: ozungetch.asm,v 1.2 2015-01-19 01:33:02 pauloscustodio Exp $
;


	PUBLIC	ozungetch2	; renamed (will be redefined if used)

	EXTERN	KeyBufGetPos


ozungetch2:

    pop    hl
    pop    de
    push   de
    push   hl

    di
    ld	   hl,KeyBufGetPos
    ld	   c,(hl)
    ld	   b,0
    inc    bc
    add    hl,bc
    add    hl,bc
    ld     (hl),e
    inc    hl
    ld     (hl),d      ; key saved
    ld	   hl,KeyBufGetPos
    ld	   a,(hl)
    or	   a
    jr	   z,ldB
    dec    a
    ld	   c,a
    jr	   ok1
ldB:
    ld	   c,0bh
ok1:
    ld	   (hl),c
    inc    hl
    ld	   a,(hl)      ; KeyBufPutPos
    cp	   c	       ; overflowed buffer
    jr	   nz,ok2
    or	   a
    jr	   z,ldB2
    dec    a
    jr	   ok3
ldB2:
    ld	   a,0bh
ok3:
    ld	   (hl),a
ok2:
    ei
    ret
