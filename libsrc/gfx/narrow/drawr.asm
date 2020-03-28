;
;       Z88 Graphics Functions - Small C+ stubs
;
;       Written around the Interlogic Standard Library
;
;       Stubs Written by D Morris - 30/9/98
;
;
;	$Id: drawr.asm $
;

; CALLER LINKAGE FOR FUNCTION POINTERS
; ----- void  drawr(int x, int y)


		SECTION   code_graphics
		
		PUBLIC    drawr
		PUBLIC	  _drawr
		
		EXTERN drawr_callee
		EXTERN ASMDISP_DRAWR_CALLEE


.drawr
._drawr
	pop	af	; ret addr
	pop de	; y
	pop hl	; x
	push hl
	push de
	push	af	; ret addr
		
   jp drawr_callee + ASMDISP_DRAWR_CALLEE
