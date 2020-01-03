; NEC PC8001 graphics library
; by Stefano Bodrato, 2018

	SECTION	code_clib
	PUBLIC	cleargraphics
   PUBLIC   _cleargraphics

	EXTERN	pc88bios

;
;	$Id: clsgraph.asm $
;

; ******************************************************************
;
;	Clear graphics	area, i.e. reset all bits and sets graphics mode
;
;	Design & programming by Gunther Strube,	Copyright (C) InterLogic 1995
;	ported by Stefano Bodrato
;
;	Registers	changed after return:
;		a.bcdehl/ixiy	same
;		.f....../....	different
;
.cleargraphics
._cleargraphics

;    in      a,($71)	; current ROM bank
;	push    af
	
	xor     a
	ld      ($E6B8),a	; Hide function key bar
	cpl
	ld      ($E6B9),a	; Color/Monochrome switch (monochrome supports underline attribute, etc..)
	
	;out     ($71),a		; main ROM bank
	
	ld		a,$98
	ld      ($E6B4),a	; Default Text attribute (0=default, $98=graphics)
	ld      b,80		; columns
	ld      c,25		; rows

	ld a,($E6A7)		; CursorMode
	res	0,a				; hide cursor
	ld ($E6A7),a
	or	$80				; complete CRTC command for cursor mode
	ld ($E6A8),a		; CursorCommand

	;call    $6f6b		; CRTSET
	ld      ix,$6f6b		; CRTSET
	call	pc88bios
	
	   
;	pop     af
;	out     ($71),a			; restore previous ROM bank

	; now let's fill the text area with NUL
	in	a,(0x32)
	push	af
	res	4,a
	out	(0x32),a
	
	ld	hl,0xF3C8		; LD HL,(E6C4h) could be also good if you are in N88 BASIC
	
	ld	a,25
loop:
	ld	d,h
	ld	e,l
	inc de
	ld	(hl),0
	ld	bc,80
	ldir
	ld de,40	; skip attribute area
	add hl,de
	dec a
	jr nz,loop
	
	pop af
	out (0x32),a

	ret
