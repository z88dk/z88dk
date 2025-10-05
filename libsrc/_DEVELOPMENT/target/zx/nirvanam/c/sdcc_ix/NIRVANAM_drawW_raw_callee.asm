; ----------------------------------------------------------------
; Z88DK INTERFACE LIBRARY FOR NIRVANA+ ENGINE - by Einar Saukas
;
; See "nirvana+.h" for further details
; ----------------------------------------------------------------

; void NIRVANAM_drawW_raw(unsigned char tile, unsigned char lin, unsigned char col)
; callee

SECTION code_clib
SECTION code_nirvanam

PUBLIC _NIRVANAM_drawW_raw_callee

EXTERN asm_NIRVANAM_drawW

_NIRVANAM_drawW_raw_callee:

   pop hl
   dec sp
   pop af          ; a = tile
   ex (sp),hl
   ld d,l          ; d = lin
   ld e,h          ; e = col

	push ix
	
	call asm_NIRVANAM_drawW
	
	pop ix
	ret
