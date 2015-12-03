; ----------------------------------------------------------------
; Z88DK INTERFACE LIBRARY FOR NIRVANA+ ENGINE - by Einar Saukas
;
; See "nirvana+.h" for further details
; ----------------------------------------------------------------

; void NIRVANA_tiles(unsigned char *addr)
; fastcall

SECTION code_lib
SECTION code_nirvanap

PUBLIC NIRVANA_tiles

EXTERN asm_NIRVANA_tiles

defc NIRVANA_tiles = asm_NIRVANA_tiles
