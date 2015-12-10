; ----------------------------------------------------------------
; Z88DK INTERFACE LIBRARY FOR NIRVANA+ ENGINE - by Einar Saukas
;
; See "nirvana+.h" for further details
; ----------------------------------------------------------------

; void NIRVANA_fillT(unsigned int attr, unsigned int lin, unsigned int col)
; callee

SECTION code_lib
SECTION code_nirvanap

PUBLIC NIRVANA_fillT_callee

EXTERN asm_NIRVANA_fillT

NIRVANA_fillT_callee:

        pop hl          ; RET address
        pop de          ; col
        pop bc
        ld d,c          ; lin
        ex (sp),hl      ; attr
        ld a,l

	jp asm_NIRVANA_fillT
