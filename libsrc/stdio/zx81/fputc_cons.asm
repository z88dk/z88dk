;
; 	Basic video handling for the ZX81
;
;	(HL)=char to display
;
;----------------------------------------------------------------
;
;	$Id: fputc_cons.asm,v 1.15 2012-04-27 12:16:57 stefano Exp $
;
;----------------------------------------------------------------
;

	XLIB	fputc_cons

	LIB     asctozx81
	LIB     restore81
	LIB     filltxt
	LIB     scrolluptxt
	LIB     zx_dfile_addr
	LIB     zx_coord_adj
	
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

	call zx_coord_adj
	call doput
	call zx_dfile_addr
	jp   zx_coord_adj


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
	call zx_dfile_addr
	xor	a		; blank
	;ld	(hl),a
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
	call zx_dfile_addr
	ld	 (hl),a

	ld	 a,(COLUMN)
	inc	 a
	ld	 (COLUMN),a
	cp	 COLUMNS		; last column ?
	ret	 nz		; no, return
 	jp	 isLF

