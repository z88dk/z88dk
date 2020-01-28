;
;       Z88 Graphics Functions - Small C+ stubs
;
;       Stefano Bodrato 19/7/2007
;
;
;       $Id: w_multipoint.asm $
;

;
; Pick a vertical or horizontal bit bar, up to 16 bits long
;
; Usage: multipoint(int hv, int length, int x, int y)
;

; CALLER LINKAGE FOR FUNCTION POINTERS


IF !__CPU_INTEL__
        SECTION code_graphics
                PUBLIC    multipoint
                PUBLIC    _multipoint

		EXTERN multipoint_callee
		EXTERN ASMDISP_MULTIPOINT_CALLEE
		

.multipoint
._multipoint

	pop	af	; ret addr
	pop de	; y
	pop hl	; x
	pop bc
	ex af,af
	ld	a,c	; length
	pop bc	; h/v
	ld	b,a
	ex af,af
	push de
	push de
	push de
	push de
	push af	; ret addr
	
	
   jp multipoint_callee + ASMDISP_MULTIPOINT_CALLEE

ENDIF
