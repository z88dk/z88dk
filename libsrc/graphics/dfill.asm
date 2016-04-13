;       Z88DK Small C+ Graphics Functions
;       Fills a screen area
;	Original code by Massimo Morra (Thanks!)
;	Ported by Stefano Bodrato
;
;	Feb 2000 - Platform dependent stack usage
;		   Stack usage should be maxy*8 (512 bytes for the Z88)
;
;	Since some platform (expecially the TI83) has very little stack space,
;	we undersize it; this will cause a crash if a big area is filled.
;
;	$Id: dfill.asm,v 1.9 2016-04-13 21:09:09 dom Exp $
;

	INCLUDE	"graphics/grafix.inc"

                SECTION         code_clib
        PUBLIC    do_fill
        EXTERN	pixeladdress


;ix points to the table on stack (above)

;Entry:
;       d=x0 e=y0


.do_fill
        ld      hl,-maxy*3	; create buffer 1 on stack
        add     hl,sp		; The stack size depends on the display height.
        ld      sp,hl		; The worst case is when we paint a blank 
        push	hl		; display starting from the center.
        pop	ix
        ld	(hl),d
        inc	hl
        ld	(hl),e
        inc	hl
        ld	(hl),255
        ld      hl,-maxy*3	; create buffer 2 on stack
        add     hl,sp
        ld      sp,hl
.loop	push	ix
	push	hl
        call	cfill
	pop	ix
	pop	hl

	ex	af,af	; Restore the Z flag
	push	af
	ex	af,af
	pop	af

	jr	nz,loop
        ld      hl,maxy*6	; restore the stack pointer (parm*2)
        add     hl,sp
        ld      sp,hl
        ret

.cfill	
	sub	a,a	; Reset the Z flag
	ex	af,af	; and save it

.next	ld	a,(ix+0)
	cp	255		; stopper ?
	ret	z		; return
	ld	b,a
	ld	c,(ix+1)

	push	bc
	
	or	a
	jr	z,l1
	
	dec	b
	call	doplot
	pop	bc
	push	bc

.l1	
	ld	a,b
	
	cp	maxy-1
	jr	z,l2
	
	inc	b
	call	doplot
	pop	bc
	push	bc

.l2	

	ld	a,c
	or	a
	jr	z,l3

	dec	c
	call	doplot

.l3	
	pop	bc

	ld	a,c
	cp	maxx-1
	jr	z,l4

	inc	c
	call	doplot

.l4	
	inc	ix
	inc	ix
	jr	next

.doplot
	push	bc
	ld	(hl),255

	push	hl
	ld	l,b
	ld	h,c
	call	pixeladdress	; bc must be saved by pixeladdress !
	pop	hl
	xor	7

	ld	b,a
	inc	b
	push	bc
	ld	a,(de)
.shift	rlca
	djnz	shift
	and	1
	pop	bc

	jr	z,dontret
	pop	de
	ret
.dontret

	inc	a
.doset	rrca
	djnz	doset

	ld	b,a
	ld	a,(de)
	or	b	; Z flag set...
	ld	(de),a

	pop	bc
	ld	(hl),b
	inc	hl
	ld	(hl),c
	inc	hl
	ld	(hl),255
	
	ex	af,af	; Save the Z flag
	
	xor	a

	ret

	SECTION	bss_clib
.spsave	defw 0
