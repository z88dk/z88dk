;
;	written by Waleed Hasan
;
;	$Id: findlib.asm,v 1.1 2002-04-10 20:16:25 dom Exp $
;

	XLIB	findlib


.findlib
	pop	hl		; ret addr
	pop	de		; &sig to look for
	push	de
	push	hl
				; save old bank2 values
	ld	h,0
	in	a,(4)
	ld	l,a
	push	hl
	in	a,(3)
	ld	l,a
	push	hl
				; REGISTER_WRITE(REG_BANK2_HI, 0x00);
	xor	a
	out	(4),a
				; for(i=0; i<25; i++)
	ld	b,25
	ld	hl,_pages

.PagLoop
	push	bc		; save loop counter
	push	hl		; save pages[]
				; REGISTER_WRITE(REG_BANK2_LO, pages[i]);
	ld	a,(hl)
	out	(3),a

	ld	b,3		; signature = 3 bytes
	ld	hl,$A003	; &signature in library
				; de already = &signature
.SigLoop
	ld	a,(de)
	cp	(hl)
	jr	nz,ChkNxtPag
	inc	hl
	inc	de
	djnz	SigLoop	
				; this should be the page!
	pop	hl		; the page in
	ld	a,(hl)
	sub	4		; Page[i]-4
	ld	h,0
	ld	l,a
	pop	bc
	jp	end

.ChkNxtPag
	pop	hl		; get pages[]
	inc	hl		; next page

	POP	bc
	DJNZ	PagLoop

	ld	hl,-1		; page not found

.end
	pop	bc		; restore old bank2 values
	ld	a,c
	out	(3),a
	pop	bc
	ld	a,c
	out	(4),a
	ret
	
	
._pages
	defb	22,23,24,43,73,77,88,98,120,121
	defb	122,124,125,126,127,128,129,130,131,132
	defb	133,134,135,136,137
