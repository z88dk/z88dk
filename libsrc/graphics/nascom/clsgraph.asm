;
;       NASCOM Graphics Functions
;
;       cls ()  -- clear screen
;
;       Stefano Bodrato - June 2003
;
;
;       $Id: clsgraph.asm,v 1.6 2017-01-02 22:57:58 aralbrec Exp $
;

	SECTION	 code_clib
        PUBLIC    cleargraphics
        PUBLIC    _cleargraphics
        EXTERN     ansi_cls

defc	vram	=	0800h
defc	vl1	=	vram+10
defc	vl2	=	vl1+64
defc	vl15	=	vram+038ah
defc	vend	=	vram+0400h

.cleargraphics
._cleargraphics

;	call	montest
;	jr	nz,nassys
;	
;; T monitor
;	ld	a,1eh
;	jp	c4ah
;
;.nassys
;; NASSYS monitor
;	ld	a,0ch
;	defb	f7h
;	ret

	ld    hl,vl1
	push  hl
	ld    b,48
blklp:
	ld    (hl),' '
	inc   hl
	djnz  blklp
	; set margin
	ld    b,16
setmgn:
	ld    (hl),0
	inc   hl
	djnz  setmgn
	; copy down screen
	ex    de,hl
	pop   hl
	ld    bc,vend-vram-64-10-6
	ldir

	ret
