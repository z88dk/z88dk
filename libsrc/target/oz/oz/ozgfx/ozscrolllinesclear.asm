;
;	Sharp OZ family functions
;
;	ported from the OZ-7xx SDK by by Alexander R. Pruss
;	by Stefano Bodrato - Oct. 2003
;
;	void ozscrolllinesclear(byte n);
;
; ------
; $Id: ozscrolllinesclear.asm,v 1.3 2016-06-28 14:48:17 dom Exp $
;

        SECTION code_clib
	PUBLIC	ozscrolllinesclear
	PUBLIC	_ozscrolllinesclear
	
	EXTERN	ozactivepage
	

ozscrolllinesclear:
_ozscrolllinesclear:
        pop     hl
        pop     de
        push    de
        push    hl

	in	a,(3)
	ld	c,a
	in	a,(4)
	ld	b,a
	push	bc

        ld      bc,(ozactivepage)
	ld	a,c
	out	(3),a
	ld	a,b
	out	(4),a

;; multiply e by 30, and put in hl

        ld      l,e
        ld      h,0

        add     hl,hl ; hl=e*2
        ld      e,l
        ld      d,h   ; de=e*2
        add     hl,hl ; hl=e*4
        add     hl,hl ; hl=e*8
        add     hl,hl ; hl=e*16
        add     hl,hl ; hl=e*32
        sbc     hl,de ; hl=e*30

        ld      (num_to_clear+1),hl

        ld      e,l
        ld      d,h

        ld      hl,2400  ;; carry should be clear
        sbc     hl,de

        ld      c,l
        ld      b,h   ;; bc=2400-num_to_clear

        ld      hl,0a000h
        add     hl,de
	ld	de,0a000h

	ldir
num_to_clear:
	ld	de,300


        ld      c,e
        ld      b,d

        ld      hl,0a000h+2400
        or      a
        sbc     hl,de

	xor	a
	ld	e,a
rpt:
	ld	(hl),e
	inc	hl
	dec	bc
	ld	a,b
	or	c
	jr	nz,rpt

	pop	bc

	ld	a,c
	out	(3),a
	ld	a,b
	out	(4),a
	ret
