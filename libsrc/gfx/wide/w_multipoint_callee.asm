;
;       Z88 Graphics Functions - Small C+ stubs
;
;       Stefano Bodrato 19/7/2007
;
;
;       $Id: w_multipoint_callee.asm $
;


; CALLER LINKAGE FOR FUNCTION POINTERS
; ----- bool  multipoint(int hv, int length, int x, int y)

;Usage: 
;pick a vertical or horizontal bit bar, up to 16 bits long


IF !__CPU_INTEL__
        SECTION code_graphics
                PUBLIC    multipoint_callee
                PUBLIC    _multipoint_callee
				PUBLIC    ASMDISP_MULTIPOINT_CALLEE

                EXTERN     w_pointxy
                EXTERN     swapgfxbk
                EXTERN     swapgfxbk1


.multipoint_callee
._multipoint_callee

	pop	af	; ret addr
	pop de	; y
	pop hl	; x
	pop bc
	ex af,af
	ld	a,c	; length
	pop bc	; h/v
	ld	b,a
	ex af,af
	push af	; ret addr

		
.asmentry

		push	ix
                call    swapgfxbk

				ld      a,b
                rr      c
				ld      bc,0
                
                jr      nc,horizontal                
.vertical
                sla     c
                rl      b
                push	af
                push	hl
                push	de
                push	bc
                call    w_pointxy
                pop     bc
                pop     de
                pop     hl
                jr      z,jv
                inc     bc
.jv             pop     af
                inc     de
                dec     a
                jr      nz,vertical
                jr      exit
				
.horizontal
                sla     c
                rl      b
                push	af
                push	hl
                push	de
                push	bc
                call    w_pointxy
                pop     bc
                pop     de
                pop     hl
                jr      z,jh
                inc     bc
.jh             pop     af
                inc     hl
                dec     a
                jr      nz,horizontal
.exit
                call    swapgfxbk1
		pop	ix
		
		
                ld      h,b
                ld      l,c
                ret

				
DEFC ASMDISP_MULTIPOINT_CALLEE = asmentry - multipoint_callee

ENDIF
