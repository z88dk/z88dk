;
;       Z88 Graphics Functions - Small C+ stubs
;
;       Written around the Interlogic Standard Library
;
;       Stubs Written by D Morris - 30/9/98
;
;       Wide resolution (int type parameters) version by Stefano Bodrato
;

;
;	$Id: w_undraw.asm $
;

;
; CALLER LINKAGE FOR FUNCTION POINTERS
; ----- void  undraw(int x, int y, int x2, int y2)

IF !__CPU_INTEL__
SECTION code_graphics
PUBLIC undraw
PUBLIC _undraw
EXTERN undraw_callee
EXTERN ASMDISP_UNDRAW_CALLEE


.undraw
._undraw
		pop af
		
		pop de
		pop	hl
		exx			; w_respixel and swapgfxbk must not use the alternate registers, no problem with w_line_r
		pop hl
		pop de
		
		push de
		push hl
		exx
		push hl
		push de
		;exx
		
		push af		; ret addr
		
   jp undraw_callee + ASMDISP_UNDRAW_CALLEE
 
ENDIF
