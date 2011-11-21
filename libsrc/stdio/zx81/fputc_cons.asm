;
; 	Basic video handling for the ZX81
;
;	(HL)=char to display
;
;	$Id: fputc_cons.asm,v 1.11 2011-11-21 07:37:37 stefano Exp $
;

	XLIB	fputc_cons

	LIB     asctozx81
	LIB     restore81
	LIB     zx_cls
	
	DEFC	ROWS=24
	DEFC	COLUMNS=32

	DEFC	COLUMN=$4039    ; S_POSN_x
	DEFC	ROW=$403A       ; S_POSN_y
;.ROW	defb	0
;.COLUMN	defb	0


; adjust coordinates from-to ZX81 ROM style
.coord_adj
	ld  hl,$1821	; (33,24) = top left screen posn
	ld  de,(COLUMN)
	and a
	sbc hl,de
	ld  (COLUMN),hl
	ret


.fputc_cons
	ld	hl,2
	add	hl,sp
	ld	(charpos+1),hl
	ld	a,(hl)
	

	cp	12
	jp  z,zx_cls
;	jr	nz,nocls
;	;call	restore81	; Assembler will swap it to iy
;	;jp	2602	; CLS
;	ld  hl,$1821	; (33,24) = top left screen posn
;	ld  (COLUMN),hl
;	ld  l,0
;	jp	filltxt
;
;.nocls

	call coord_adj
	call doput
	jr 	coord_adj

.doput

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
	inc hl
	ld ($400E),hl	; DF_CC ..current ZX81 cursor position on display file
	ret
