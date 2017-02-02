; ----------------------------------------------------------------
; Z88DK INTERFACE LIBRARY FOR NIRVANA+ ENGINE - by Einar Saukas
;
; See "nirvana+.h" for further details
; ----------------------------------------------------------------

; void NIRVANA_fillT_raw(unsigned int attr, unsigned int lin, unsigned int col)
; callee

SECTION code_clib
SECTION code_nirvanap

PUBLIC NIRVANAP_fillT_raw_callee

EXTERN asm_NIRVANAP_fillT

NIRVANAP_fillT_raw_callee:

        pop hl          ; RET address
        pop de          ; col
        pop bc
        ld d,c          ; lin
        ex (sp),hl      ; attr
        ld a,l

	jp asm_NIRVANAP_fillT
