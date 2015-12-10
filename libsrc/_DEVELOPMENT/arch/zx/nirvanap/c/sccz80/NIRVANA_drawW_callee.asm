; ----------------------------------------------------------------
; Z88DK INTERFACE LIBRARY FOR NIRVANA+ ENGINE - by Einar Saukas
;
; See "nirvana+.h" for further details
; ----------------------------------------------------------------

; void NIRVANA_drawW(unsigned int tile, unsigned int lin, unsigned int col)
; callee

SECTION code_lib
SECTION code_nirvanap

PUBLIC NIRVANA_drawW_callee

EXTERN asm_NIRVANA_drawW

NIRVANA_drawW_callee:

        pop hl          ; RET address
        pop de          ; col
        pop bc
        ld d,c          ; lin
        ex (sp),hl      ; tile
        ld a,l

	jp asm_NIRVANA_drawW
