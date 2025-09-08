; ----------------------------------------------------------------
; Z88DK INTERFACE LIBRARY FOR NIRVANA+ ENGINE - by Einar Saukas
;
; See "nirvana+.h" for further details
; ----------------------------------------------------------------

; void NIRVANAP_drawW_raw(unsigned int tile, unsigned int lin, unsigned int col)
; callee

SECTION code_clib
SECTION code_nirvanap

PUBLIC NIRVANAP_drawW_raw_callee

EXTERN asm_NIRVANAP_drawW

NIRVANAP_drawW_raw_callee:

        pop hl          ; RET address
        pop de          ; col
        pop bc
        ld d,c          ; lin
        ex (sp),hl      ; tile
        ld a,l

	jp asm_NIRVANAP_drawW

; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _NIRVANAP_drawW_raw_callee
defc _NIRVANAP_drawW_raw_callee = NIRVANAP_drawW_raw_callee
ENDIF

