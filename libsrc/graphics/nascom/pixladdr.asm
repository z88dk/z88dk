;
;       NASCOM Graphics Functions
;
;       pixeladdress -- compute the screen addr and pixel mask for graphics
;
;       Stefano Bodrato - June 2003
;
;
;	$Id: pixladdr.asm,v 1.2 2003-06-30 15:58:53 stefano Exp $
;

	XLIB	pixeladdress

; ******************************************************************
;
; Get absolute	pixel address in map of virtual (x,y) coordinate.
;
; in:  hl	= (x,y) coordinate of pixel (h,l)
;
; out: de	= address	of pixel byte
;	   a	= bit number of byte where pixel is to be placed
;	  fz	= 1 if bit number is 0 of pixel position
;

.pixeladdress

	; Adjust column and find the right bit mask

	push	hl
	
	ld	a,1		; 2 bits per character
	and	h		; Odd or even bit
	push	af		; Save it
	
        ;pop	hl
        ;push	hl		; pick row
	
	ld	h,0		; hl=row
	ld	de,0		; Zero line count
	ld	bc,3		; 3 blocks per line
	inc	hl
DIV3LP:	sbc	hl,bc		; subtract 3
	inc	de		; count the subtractions
	jr	z,DIV3EX	; exactly - Exit
	jp	p,DIV3LP	; more to do
	;jr	nc,DIV3LP
DIV3EX:	add	hl,bc		; restore number
	pop	af		; restore column and odd/even

	ld	a,l
	jr	z,evenbit
	srl	a
	srl	a
	srl	a
evenbit:


;	or	a		; set flags (NZ or Z)
;	ld	a,l		; get remainder from /3
;	jr	z,NOREMD	; no remainder
;	add	a,3		; adjust remainder
;NOREMD: ld	b,a		; bit number+1 to B
;	ld	a,1
;SHFTBT: rlca			; shift bit left
;	djnz	SHFTBT		; count shifts
;	rra			; restore correct place
	
	pop	hl
	push	af
	
	ld	b,e		; save adjusted line
	
	
	; Adjust column
	
	ld	a,h		; get column
	rra			; divide by 2
	add	1
	and	63
	ld	c,a		; save adjusted column
	
	
	; Compute the screen address
	
	ld	d,0		; we are going to use "add de" a couple of times..

	ld	a,b		; get adjusted line
	and	a
	jr	nz,nozline
	ld	hl,0BC0h+10-65	; SCREEN VDU address (0,0)
	
	jr	zline

.nozline
	ld	hl,800h+10-65	; SCREEN VDU address (1,0)

	ld	e,b		; Put adjusted line onto DE
	dec	e
	
	ld	b,64		; 64 Bytes per line
ADD64X: add	hl,de		; Add line
	djnz	ADD64X		; SIXTY FOUR TIMES!!!
	
.zline
	ld	e,c
	add     hl,de		; Add column to address
	
	ld	a,(hl)
	and	@11000000
	;cp	@11000000
	;jr	z,noinitchar
	jr	nz,noinitchar	; initialize graph block ?
	
	ld	a,@11000000	; base block for graphics
	ld	(hl),a		; 

	pop	af
	jr	goover

.noinitchar
	
	pop	af
	and	63

.goover	
	
	ld	d,h
	ld	e,l
	
;	inc	a
	
	ret
