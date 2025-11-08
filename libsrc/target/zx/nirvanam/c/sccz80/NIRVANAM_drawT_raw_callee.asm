; ----------------------------------------------------------------
; Z88DK INTERFACE LIBRARY FOR NIRVANA+ ENGINE - by Einar Saukas
;
; See "nirvana+.h" for further details
; ----------------------------------------------------------------

; void NIRVANAM_drawT_raw(unsigned int tile, unsigned int lin, unsigned int col)
; callee

SECTION code_clib
SECTION code_nirvanam

PUBLIC NIRVANAM_drawT_raw_callee

EXTERN asm_NIRVANAM_drawT

NIRVANAM_drawT_raw_callee:

        pop hl          ; RET address
        pop de          ; col
        pop bc
        ld d,c          ; lin
        ex (sp),hl      ; tile
        ld a,l

	jp asm_NIRVANAM_drawT

; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _NIRVANAM_drawT_raw_callee
defc _NIRVANAM_drawT_raw_callee = NIRVANAM_drawT_raw_callee
ENDIF

