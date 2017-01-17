;
;	TIKI-100 graphics routines
;	by Stefano Bodrato, Fall 2015
;
;	Modified by Frode van der Meeren
;
; void __FASTCALL__ gr_defmod(uchar mode)
;
; Set graphics mode
; (1 = BW mode, 2 = four color mode, 3 = 16 color mode)
;
;	Changelog:
;
;	v1.3 - FrodeM
;	   * Use address $F04D to store graphics mode instead of dedicated byte
;	   * Changed 2-byte left-shifts to 1-byte add a,a
;
;	$Id: gr_defmod.asm,v 1.4 2016-06-10 23:01:47 dom Exp $
;

	SECTION code_clib
PUBLIC gr_defmod
PUBLIC _gr_defmod

gr_defmod:
_gr_defmod:
	ld	a,l
	and	3
	add	a,a
	add	a,a
	add	a,a
	add	a,a
	ld	b,a

	ld	hl,$F04D
	DI
	ld	a,(hl)
	and	$CF
	or	b
	LD	(hl),A		; Video port: copy of the value sent to the video port address 0CH
	OUT	($0C),A		; set graphics mode
	EI
	RET
