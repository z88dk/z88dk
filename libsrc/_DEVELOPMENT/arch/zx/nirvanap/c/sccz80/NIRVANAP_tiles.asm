; ----------------------------------------------------------------
; Z88DK INTERFACE LIBRARY FOR NIRVANA+ ENGINE - by Einar Saukas
;
; See "nirvana+.h" for further details
; ----------------------------------------------------------------

; void NIRVANAP_tiles(unsigned char *addr)
; fastcall

SECTION code_clib
SECTION code_nirvanap

PUBLIC NIRVANAP_tiles

EXTERN asm_NIRVANAP_tiles

defc NIRVANAP_tiles = asm_NIRVANAP_tiles
