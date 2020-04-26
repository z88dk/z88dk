;
;       Z88 Graphics Functions - Small C+ stubs
;
;       Written around the Interlogic Standard Library
;
;       Stubs Written by D Morris - 30/9/98
;
;
;	$Id: point_callee.asm $
;


IF !__CPU_INTEL__ & !__CPU_GBZ80__
; CALLER LINKAGE FOR FUNCTION POINTERS
; ----- void  point(int x, int y)
;Result is true/false


        SECTION code_graphics
		
                PUBLIC    point_callee
                PUBLIC    _point_callee
				PUBLIC    ASMDISP_POINT_CALLEE
				
                EXTERN     swapgfxbk
                EXTERN    swapgfxbk1

                EXTERN     pointxy
				

.point_callee
._point_callee

	pop	af	; ret addr
	pop hl	; y
	pop de
	ld	h,e	; x
	push	af	; ret addr

.asmentry
		push	ix
                call    swapgfxbk
                call    pointxy
				
                push    af
                call    swapgfxbk1
                pop     af
		pop	ix
                ld      hl,1
                ret     nz       ;pixel set
                dec     hl
                ret

DEFC ASMDISP_POINT_CALLEE = asmentry - point_callee
ENDIF
