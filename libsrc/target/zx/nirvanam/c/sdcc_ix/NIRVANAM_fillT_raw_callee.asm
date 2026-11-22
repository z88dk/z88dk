; ----------------------------------------------------------------
; Z88DK INTERFACE LIBRARY FOR NIRVANA+ ENGINE - by Einar Saukas
;
; See "nirvana+.h" for further details
; ----------------------------------------------------------------

; void NIRVANAM_fillT_raw(unsigned char attr, unsigned char lin, unsigned char col)
; callee

SECTION code_clib
SECTION code_nirvanam

PUBLIC _NIRVANAM_fillT_raw_callee

EXTERN asm_NIRVANAM_fillT

_NIRVANAM_fillT_raw_callee:

   pop hl
   pop de          ; d = lin
   ld a,e          ; a = attr
   dec sp
   ex (sp),hl
   ld e,h          ; e = col

	jp asm_NIRVANAM_fillT
