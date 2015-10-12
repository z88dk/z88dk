;
; 	ANSI Video handling for the Philips VG-5000
;
; 	Handles colors
;
;	Scrollup
;
;	Stefano Bodrato - 2014
;
;	$Id: f_ansi_scrollup.asm,v 1.3 2015-10-12 19:47:47 stefano Exp $
;

	PUBLIC  ansi_SCROLLUP
	EXTERN  ansi_del_line

	DEFC	ROWS=25
	DEFC	COLUMNS=40

.ROW
	defb 0
.COLUMN
	defb 0
	
.ansi_SCROLLUP
;	ld hl,(ROW)
;	push hl
	ld  hl,0
	ld  (ROW),hl
	ld  bc,40*24
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
	inc hl
	ld  a,(hl)
	ld	(attrput+1),a
	call	charput
	pop bc
	dec bc
	ld	a,b
	or  c
	jr nz,scloop
;	pop hl
;	ld (ROW),hl
;	ld h,0
;	ld l,23
;	ld (ROW),hl
;	ld a,l
;	inc a
	ld a,24
	jp ansi_del_line

	
.charput
	ld	 a,0		; SMC to set the current char value
	
	push af
	ld	 a,(COLUMN)
	cp	 COLUMNS    ; top-right column ?   In this way we wait..
	call z,isLF     ; .. to have a char to print before issuing a CR
	pop  af

	ld	 d,a
.attrput	
	ld	e,7		; SMC to set the current attribute value
	
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
	call   $92		; direct video access
	pop de
	pop  hl
	push de
	call   $a7		; video buffer access (keep a copy to scroll)
	pop  de
	ld   a,d
	ld   (hl),a
	inc  hl
	ld   a,e
	ld   (hl),a

	ld	 a,(COLUMN)
	inc	 a
	ld	 (COLUMN),a
	cp	 COLUMNS		; last column ?
	ret	 nz		; no, return

.isLF
	xor a
	ld (COLUMN),a   ; automatic CR
	ld a,(ROW)
	inc a
	ld (ROW),a
	ret
