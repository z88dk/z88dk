;
;    Philips VG5000 Routines
;
;    Print character to the screen
;
;    Jun. 2014 -Joaopa, Stefano Bodrato
;
;
;    $Id: fputc_cons.asm,v 1.7 2016-06-16 19:40:21 dom Exp $
;
	
	SECTION code_clib
	PUBLIC  fputc_cons_native
;
; Entry:        char to print
;

	DEFC	ROWS=25
	DEFC	COLUMNS=40


defc ROW	= $4805
defc COLUMN	= $4806


.fputc_cons_native

	ld	ix,$47FA
	ld	hl,2
	add	hl,sp
	ld	a,(hl)
	ld	(charput+1),a

	cp	12		; CLS
	jr	nz,nocls
	ld  hl,0
	ld  (ROW),hl
	ld  bc,ROWS*COLUMNS
.cls
	push hl
	ld	a,32
	ld	(charput+1),a
.clsloop
	push bc
	call	charput
	pop bc
	dec bc
	ld  a,b
	or  c
	jr  nz,clsloop
	pop hl
	ld  (ROW),hl
	ret
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
	
	ld	 a,(COLUMN)
	ld   l,a
	ld	 a,(ROW)
	ld   h,a
	push hl
	and  a
	jr   z,zrow
	add  7		; bias the default scroll register settings and so on..
.zrow
	ld   h,a
	push de
	ld   a,64+128
	or   e
	ld   e,a
	call   $92		; direct video access
	pop de
	pop  hl
	push de
	call   $a7		; video buffer access (keep a copy to scroll)
	pop  de
	ld   a,d
	ld   (hl),a

	ld	 a,(COLUMN)
	inc	 a
	ld	 (COLUMN),a
	cp	 COLUMNS		; last column ?
	ret	 nz		; no, return
 	jp	 isLF


scrolluptxt:
	ld  hl,0
	ld  (ROW),hl
	ld  bc,ROWS*COLUMNS-COLUMNS
.scloop
	ld	 a,(COLUMN)
	ld   l,a
	ld	 a,(ROW)
	inc  a
	ld   h,a
	push bc
	call   $a7
	ld  a,(hl)
	ld	(charput+1),a
	call	charput
	pop bc
	dec bc
	ld	a,b
	or  c
	jr nz,scloop
	ld bc,COLUMNS-1
	ld hl,(ROW)
	jp cls


;	cp	12		; CLS
;	jp  z,$9e

;	ld  hl,charput
;	call  $36aa


;sync:
;	ei
;	rst 38h
;	rst 38h
;	rst 38h
;	rst 38h
;	rst 38h
;	rst 38h
;	rst 38h
;	rst 38h
;	di
;	ret
