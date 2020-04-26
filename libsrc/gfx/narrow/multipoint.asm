;
;       Z88 Graphics Functions - Small C+ stubs
;
;       Stefano Bodrato 19/7/2007
;
;
;       $Id: multipoint.asm $
;

IF !__CPU_INTEL__ & !__CPU_GBZ80__
;
; Pick a vertical or horizontal bit bar, up to 16 bits long
;
; Usage: multipoint(int hv, int length, int x, int y)
;

; CALLER LINKAGE FOR FUNCTION POINTERS


        SECTION code_graphics
                PUBLIC    multipoint
                PUBLIC    _multipoint

		EXTERN multipoint_callee
		EXTERN ASMDISP_MULTIPOINT_CALLEE
		

.multipoint
._multipoint

	pop	af	; ret addr
	pop hl	; y
	pop de	; x
	ld	h,e
	pop bc
	ld	b,c	; length
	pop de
	ld	c,e	; h/v
	push de
	push bc	; just to re-balance the stack
	push bc
	push hl
	push	af	; ret addr
	
	
   jp multipoint_callee + ASMDISP_MULTIPOINT_CALLEE
ENDIF
