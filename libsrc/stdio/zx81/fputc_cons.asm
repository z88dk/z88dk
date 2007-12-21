;
; 	Basic video handling for the ZX81
;
;	(HL)=char to display
;
;	$Id: fputc_cons.asm,v 1.7 2007-12-21 08:04:24 stefano Exp $
;

	XLIB	fputc_cons
	LIB	asctozx81
	XREF	restore81
	
	DEFC	ROWS=24
	DEFC	COLUMNS=32


.ROW	defb	0
.COLUMN	defb	0


.fputc_cons
	ld	hl,2
	add	hl,sp
	ld	(charpos+1),hl
	ld	a,(hl)

	cp	12
	jr	nz,nocls
	xor	a
	ld	(ROW),a
 	ld	(COLUMN),a
	call	restore81	; Assembler will swap it to iy
	jp	2602	; CLS
.nocls
	cp 13		; CR
	jr	z,isLF
	cp     10	; LF?
	jr     nz,NoLF
.isLF

	xor a
	ld (COLUMN),a   ; automatic CR
	ld a,(ROW)
	inc a
	ld (ROW),a
	cp ROWS		; Out of screen?
	ret nz		; no, return
	ld a,ROWS-1
	ld (ROW),a

; scroll up
	ld	hl,(16396)
	inc	hl
	ld	d,h
	ld	e,l
	ld	bc,33
	add	hl,bc
	ld	bc,33*23-1
	ldir
	ld	h,d	; clean last line
	ld	l,e
	inc	hl
	inc	de
	inc	de
	ld	(hl),0
	ld	c,31
	ldir
	ret
.NoLF

	cp     8   ; BackSpace

	jr	nz,NoBS
	ld	hl,COLUMN
	xor	a
	push	hl
	call	charput	 ; a=0 -> blank
	pop	hl
	cp	(hl)
	jr	z,firstc ; are we in the first column?
	dec	(hl)
	ret
.firstc
	ld	a,(ROW)
	and	a
	ret	z
	dec	a
	ld	(ROW),a
	ld	a,COLUMNS-1
	ld     (COLUMN),a
 	ret
.NoBS
.charpos
	ld	hl,0
	call	asctozx81
	bit	6,a		; filter the dangerous codes
	ret	nz
	call	charput

	ld	a,(COLUMN)
	inc	a
	ld	(COLUMN),a
	cp	COLUMNS		; last column ?
	ret	nz		; no, return
 	jp	isLF



.charput
	push	af
	ld	hl,(16396)
	inc	hl
	ld	a,(ROW)
	and	a
	jr	z,r_zero
	ld	b,a
	ld	de,33	; 32+1. Every text line ends with an HALT
.r_loop
	add	hl,de
	djnz	r_loop
.r_zero
	ld	a,(COLUMN)
	ld	d,0
	ld	e,a
	add	hl,de
	pop	af
	ld	(hl),a
	ret
