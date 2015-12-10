; ----------------------------------------------------------------
; Z88DK INTERFACE LIBRARY FOR NIRVANA+ ENGINE - by Einar Saukas
;
; See "nirvana+.h" for further details
; ----------------------------------------------------------------

; void NIRVANA_printC(unsigned int ch, unsigned char *attrs, unsigned int lin, unsigned int col)
; callee

SECTION code_lib
SECTION code_nirvanap

PUBLIC NIRVANA_printC_callee

EXTERN asm_NIRVANA_printC

NIRVANA_printC_callee:

        pop hl          ; RET address
        pop de          ; col
        pop bc
        ld d,c          ; lin
        pop bc          ; attrs
        ex (sp),hl      ; ch
        ld a,l

	jp asm_NIRVANA_printC
