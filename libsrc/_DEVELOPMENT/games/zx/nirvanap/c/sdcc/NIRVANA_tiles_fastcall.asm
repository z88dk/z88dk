; ----------------------------------------------------------------
; Z88DK INTERFACE LIBRARY FOR NIRVANA+ ENGINE - by Einar Saukas
;
; See "nirvana+.h" for further details
; ----------------------------------------------------------------

; void NIRVANA_tiles(unsigned char *addr)
; fastcall

SECTION code_lib
SECTION code_nirvanap

PUBLIC _NIRVANA_tiles_fastcall

EXTERN asm_NIRVANA_tiles

defc _NIRVANA_tiles_fastcall = asm_NIRVANA_tiles
