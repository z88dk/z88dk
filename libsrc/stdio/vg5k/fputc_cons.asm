;
;    Philips VG5000 Routines
;
;    Print character to the screen
;
;    Jun. 2014 -Joaopa, Stefano Bodrato
;
;
;    $Id: fputc_cons.asm,v 1.3 2015-01-19 01:33:21 pauloscustodio Exp $
;

    PUBLIC  fputc_cons
;
; Entry:        char to print
;

	DEFC	ROWS=25
	DEFC	COLUMNS=40


	.ROW	defb	0
.COLUMN	defb	0


.fputc_cons

	ld	ix,$47FA
	ld	hl,2
	add	hl,sp
	ld	a,(hl)
	ld	(charput+1),a

	cp	12		; CLS
	jr	nz,nocls
	
	ld  hl,0
	ld  (ROW),hl
	push hl
	ld	a,32
	ld	(charput+1),a
	ld  bc,ROWS*COLUMNS
.clsloop
	push bc
	call	charput
	pop bc
	dec bc
	ld	a,b
	or  c
	jr nz,clsloop
	pop hl
	ld  (ROW),hl
.nocls



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
	cp	(hl)
	jr	z,firstc ; are we in the first column?
	dec	(hl)
	push hl
	ld	a,32
	call charput+2
	pop hl
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


.charput
	ld	 a,0
	
	
	push af
	ld	 a,(COLUMN)
	cp	 COLUMNS    ; top-right column ?   In this way we wait..
	call z,isLF     ; .. to have a char to print before issuing a CR
	pop  af

	ld	 d,a
	
	ld	e,7		; white on black
	
	ld	 a,(ROW)
	and  a
	jr   z,zrow
	add  7
.zrow
	ld   h,a
	ld	 a,(COLUMN)
	ld   l,a

	call   $92

	ld	 a,(COLUMN)
	inc	 a
	ld	 (COLUMN),a
	cp	 COLUMNS		; last column ?
	ret	 nz		; no, return
 	jp	 isLF


scrolluptxt:
	ret
