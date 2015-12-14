; ----------------------------------------------------------------
; Z88DK INTERFACE LIBRARY FOR NIRVANA+ ENGINE - by Einar Saukas
;
; See "nirvana+.h" for further details
; ----------------------------------------------------------------

; void NIRVANAP_tiles(unsigned char *addr)
; fastcall

SECTION code_clib
SECTION code_nirvanap

PUBLIC _NIRVANAP_tiles_fastcall

EXTERN asm_NIRVANAP_tiles

defc _NIRVANAP_tiles_fastcall = asm_NIRVANAP_tiles
