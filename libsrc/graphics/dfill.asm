;       Z88DK Small C+ Graphics Functions
;       Fills a screen area
;	Original code donated by Massimo Morra (Thanks!)
;	Ported by Stefano Bodrato
;

        XLIB    do_fill
        LIB	pixeladdress
	LIB	plotpixel

.fflag	defb	0

;ix points to table on stack (above)

;Entry:
;       d=x0 e=y0

.do_fill

        ld      hl,-1500	; create buffer 1 on stack
        add     hl,sp		; Massimo said: in the worst of cases a buffer 
        ld      sp,hl		; should be 1456 bytes for the Spectrum display.
        push	hl		; It depends on the display height.
        pop	ix
        ld	(hl),d
        inc	hl
        ld	(hl),e
        inc	hl
        ld	(hl),255
        ld      hl,-1500	; create buffer 2 on stack
        add     hl,sp
        ld      sp,hl
.loop	push	ix
	push	hl
        call	cfill
	pop	ix
	pop	hl
	ld	a,(fflag)
	or	a
	jr	nz,loop
        ld      hl,3000		; restore stack pointer
        add     hl,sp
        ld      sp,hl
        ret

.cfill	xor	a
	ld	(fflag),a
.next	ld	a,(ix+0)
	cp	255		; stopper ?
	ret	z		; return
	ld	b,a
	ld	c,(ix+1)

	push	bc
	dec	b
	call	doplot
	pop	bc
	push	bc

.l1	
	inc	b
	call	doplot
	pop	bc
	push	bc

.l2	
	dec	c
	call	doplot

.l3	
	pop	bc
	inc	c
	call	doplot

.l4	
	inc	ix
	inc	ix
	jr	next

.doplot
	push	bc
	ld	(hl),255

; Original Pixel-Address Spectrum call...
;	ex	de,hl
;	call	$22B1
;	ex	de,hl

; ...changed in:  - - - - - - -
	push	hl
	ld	l,b
	ld	h,c
	call	pixeladdress
	pop	hl
	xor	7
; - - - - - - - - - - - - - - -

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
	or	b
	ld	(de),a

	pop	bc
	ld	(hl),b
	inc	hl
	ld	(hl),c
	inc	hl
	ld	(hl),255
	ld	(fflag),a
	
	xor	a

	ret
