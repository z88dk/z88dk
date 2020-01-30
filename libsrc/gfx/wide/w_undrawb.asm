;
; UnDrawbox
;
; Generic high resolution version
;

;
;	$Id: w_undrawb.asm $
;

IF !__CPU_INTEL__
SECTION code_graphics
PUBLIC undrawb
PUBLIC _undrawb
EXTERN undrawb_callee
EXTERN ASMDISP_UNDRAWB_CALLEE

	
.undrawb
._undrawb

		pop af
		
		pop de
		pop	hl
		exx			; w_plotpixel and swapgfxbk must not use the alternate registers, no problem with w_line_r
		pop de
		pop hl
		
		push hl
		push de
		exx
		push hl
		push de
		
		push af		; ret addr
		
   jp undrawb_callee + ASMDISP_UNDRAWB_CALLEE
ENDIF
