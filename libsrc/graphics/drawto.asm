;
;       Z88 Graphics Functions - Small C+ stubs
;
;       Written around the Interlogic Standard Library
;
;       Stubs Written by D Morris - 30/9/98
;
;
;	$Id: drawto.asm $
;

; CALLER LINKAGE FOR FUNCTION POINTERS
; ----- void  drawto(int x2, int y2)


		SECTION   code_graphics
		
		PUBLIC    drawto
		PUBLIC	  _drawto
		
		EXTERN drawto_callee
		EXTERN ASMDISP_DRAWTO_CALLEE


.drawto
._drawto
	pop	af	; ret addr
	pop de	; y2
	pop hl
	push hl
	push de
	ld	d,l	; x2
	push	af	; ret addr
		
   jp drawto_callee + ASMDISP_DRAWTO_CALLEE
