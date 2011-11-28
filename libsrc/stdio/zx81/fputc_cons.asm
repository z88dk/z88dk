;
; 	Basic video handling for the ZX81
;
;	(HL)=char to display
;
;	$Id: fputc_cons.asm,v 1.13 2011-11-28 20:14:50 stefano Exp $
;

	XLIB	fputc_cons

	LIB     asctozx81
	LIB     restore81
	LIB     filltxt
	LIB     scrolluptxt
	
	DEFC	ROWS=24
	DEFC	COLUMNS=32

	DEFC	COLUMN=$4039    ; S_POSN_x
	DEFC	ROW=$403A       ; S_POSN_y
;.ROW	defb	0
;.COLUMN	defb	0


.fputc_cons
	ld	hl,2
	add	hl,sp
	ld	(charpos+1),hl
	ld	a,(hl)

	ld	l,0
	cp	12		; CLS
	jp	z,filltxt

	call coord_adj
	call doput
	call getaddr
.coord_adj             ; adjust coordinates from-to ZX81 ROM style
	ld  hl,$1821       ; (33,24) = top left screen posn
	ld  de,(COLUMN)
	and a
	sbc hl,de
	ld  (COLUMN),hl
	ret


.doput
	
	cp  13		; CR?
	jr  z,isLF
	cp  10      ; LF?
	jr  nz,NoLF
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
	jp  scrolluptxt

.NoLF

	cp  8   ; BackSpace
	jr	nz,NoBS

	ld	hl,COLUMN
	push	hl
	call getaddr
	xor	a		; blank
	ld	(hl),a
	pop	hl
	cp	(hl)
	jr	z,firstc ; are we in the first column?
	dec	(hl)
	ret

.firstc
	ld	 a,(ROW)
	and	 a
	ret	 z
	dec	 a
	ld	 (ROW),a
	ld	 a,COLUMNS-1
	ld   (COLUMN),a
 	ret

.NoBS

.charpos
	ld	 hl,0
	call asctozx81
	bit	 6,a		; filter the dangerous codes
	ret	 nz

	push af
	ld	 a,(COLUMN)
	cp	 COLUMNS    ; top-right column ?   In this way we wait..
	call z,isLF     ; .. to have a char to print before issuing a CR
	pop  af
	call getaddr
	ld	 (hl),a

	ld	 a,(COLUMN)
	inc	 a
	ld	 (COLUMN),a
	cp	 COLUMNS		; last column ?
	ret	 nz		; no, return
 	jp	 isLF


.getaddr
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
	ld ($400E),hl	; DF_CC ..current ZX81 cursor position on display file
	pop	af
	ret
	
