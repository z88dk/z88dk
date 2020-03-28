;
;	written by Waleed Hasan
;
; Fixed list of pages (were off by 4)
; Graham R. Cobb 19 May 2002

	PUBLIC	findlib
   PUBLIC   _findlib


.findlib
._findlib
	pop	hl		; ret addr
	pop	de		; &signature to look for
	push	de
	push	hl
;
;ASM entry point
; i/p :	DE = points to signature to look for (zero terminated)
; o/p : HL = library page
;	   = -1 if not found
;
.findlib_asm
				; save old bank2 values
	ld	c,3		; c=3
	in	l,(c)
	inc	c		; c=4
	in	h,(c)
	push	hl

				; REGISTER_WRITE(REG_BANK2_HI, 0x00);
	xor	a
	out	(c),a		; c=4
				; for(i=0; i<25; i++)
	ld	hl,_pages
	dec	c		; c=3
.PagLoop
				; REGISTER_WRITE(REG_BANK2_LO, pages[i]);
	ld	a,(hl)
	and	a		; is it pages end-marker?
	jr	z,LibNotFound
	out	(c),a		; c=3

	push	hl		; save pages[]
	push	de		; we should save &sig
	ld	hl,$A003	; &SIGnature in library
				; de already = &sig
.SigLoop
	ld	a,(de)
	and	a		; end of seg?
	jr	z,LibFound	; yes - we found it!

	cp	(hl)
	jr	nz,ChkNxtPag

	inc	hl		; next SIG char
	inc	de		; next sig char
	jr	SigLoop


.LibFound			; we found the library
	pop	de		; &sig
	pop	hl		; the page in
	ld	a,(hl)
	sub	4		; Page[i]-4
	ld	h,0
	ld	l,a
	jr	end

.ChkNxtPag
	pop	de		; &sig
	pop	hl		; get pages[]
	inc	hl		; next page
	jr	PagLoop

.LibNotFound
	ld	hl,-1		; page not found
.end

	pop	de		; restore old bank2 values
	ld	c,3		; c=3
	out	(c),e
	inc	c		; c=4
	out	(c),d
	ret

._pages
	; We first search the pages loaded by Adder
	defb	26,27,28
	defb	47,77,81,92,102
	defb	124,125,126
	defb	136,137,138,139,140,141
	; Then a couple of pages that Adder does not load today but might in 
	; the future
	defb	142,143	
	defb	127,69,70,71,84,85,86,97	; Web/Calc/Clock pages
	; We check the standard addin slots last because addins copied 
	; using Adder are not deleted until overwritten
	defb	128,129,130,131,132,133,134,135
	defb	0		; pages end-marker

