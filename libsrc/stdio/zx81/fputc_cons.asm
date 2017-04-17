;
; 	Basic video handling for the ZX81
;
;	(HL)=char to display
;
;----------------------------------------------------------------
;
;	$Id: fputc_cons.asm,v 1.21 2016-05-15 20:15:46 dom Exp $
;
;----------------------------------------------------------------
;

        SECTION code_clib
	PUBLIC	fputc_cons_native

	EXTERN     asctozx81
	EXTERN     restore81
	EXTERN     filltxt
	EXTERN     scrolluptxt
	EXTERN     zx_dfile_addr
	EXTERN     zx_coord_adj
	
	DEFC	ROWS=24
	DEFC	COLUMNS=32

IF FORzx80
	DEFC   COLUMN=$4024    ; S_POSN_x
	DEFC   ROW=$4025       ; S_POSN_y
ELSE
	DEFC    COLUMN=$4039    ; S_POSN_x
	DEFC    ROW=$403A       ; S_POSN_y
ENDIF

;.ROW	defb	0
;.COLUMN	defb	0


.fputc_cons_native

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
IF STANDARDESCAPECHARS
	cp  10		; CR?
	jr  z,isLF
	cp  13      ; LF?
	jr  nz,NoLF
ELSE
	cp  13		; CR?
	jr  z,isLF
	cp  10      ; LF?
	jr  nz,NoLF
ENDIF
.isLF
	xor a
	ld (COLUMN),a   ; automatic CR
	ld a,(ROW)
	inc a
	ld (ROW),a
	cp ROWS         ; out of screen?
	ret nz
	dec a
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

; ----  output character ----
	push af
	ld a,(ROW)
	cp ROWS		; Out of screen?
	jr nz, noscroll
	ld a,ROWS-1
	ld (ROW),a
	call  scrolluptxt
.noscroll
	pop af
	
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

