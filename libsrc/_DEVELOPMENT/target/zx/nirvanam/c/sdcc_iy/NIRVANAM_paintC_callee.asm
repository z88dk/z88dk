; ----------------------------------------------------------------
; Z88DK INTERFACE LIBRARY FOR NIRVANA+ ENGINE - by Einar Saukas
;
; See "nirvana+.h" for further details
; ----------------------------------------------------------------

; void NIRVANAM_paintC(void *attrs, unsigned char lin, unsigned char col)
; callee

SECTION code_clib
SECTION code_nirvanam

PUBLIC _NIRVANAM_paintC_callee

EXTERN asm_NIRVANAM_paintC

_NIRVANAM_paintC_callee:

   pop hl
   pop bc          ; bc = attrs
   ex (sp),hl
   ld d,l          ; d = lin
   ld e,h          ; e = col

	jp asm_NIRVANAM_paintC
