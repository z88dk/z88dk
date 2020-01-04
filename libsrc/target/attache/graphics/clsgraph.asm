	INCLUDE	"graphics/grafix.inc"

                SECTION         code_clib
	PUBLIC	cleargraphics
   PUBLIC   _cleargraphics
   PUBLIC   GFX_COUT
   PUBLIC	LINDSP

	EXTERN	base_graphics

;
;	$Id: clsgraph.asm,v 1.7 2017-01-02 21:51:24 aralbrec Exp $
;

; ******************************************************************
;
;	Clear graphics	area, i.e. reset all bits in graphics
;	window (256x64	pixels)
;
;	Design & programming by Gunther Strube,	Copyright	(C) InterLogic	1995
;
;	Registers	changed after return:
;		a.bcdehl/ixiy	same
;		.f....../....	different
;

.CONOUT		JP 0
.LINDSP		JP 0

.cleargraphics
._cleargraphics

	LD	HL,(1)	; Warm BOOT, let's find the direct BIOS position entries to avoid BDOS
	LD	DE,9
	ADD	HL,DE
	LD	(CONOUT+1),HL
	LD	DE,71H
	ADD	HL,DE
	LD	(LINDSP+1),HL

	ld	c,27
	call GFX_COUT
	;ld	c,'6'  ; disable graphics
	ld	c,'\\'  ; clear screen and reset parameters
	call GFX_COUT
	
	ld	c,27
	call GFX_COUT
	ld	c,'7'  ; enable graphics
	
GFX_COUT:
	PUSH	HL
	PUSH	DE
	CALL	CONOUT
	POP	DE
	POP	HL
	RET

