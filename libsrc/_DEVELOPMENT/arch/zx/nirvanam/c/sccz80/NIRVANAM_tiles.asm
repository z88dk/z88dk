; ----------------------------------------------------------------
; Z88DK INTERFACE LIBRARY FOR THE NIRVANA ENGINE - by Einar Saukas
;
; See "nirvana-.h" for further details
; ----------------------------------------------------------------

; void NIRVANAM_tiles(unsigned char *addr)
; fastcall

SECTION code_clib
SECTION code_nirvanam

PUBLIC NIRVANAM_tiles

EXTERN asm_NIRVANAM_tiles

defc NIRVANAM_tiles = asm_NIRVANAM_tiles
