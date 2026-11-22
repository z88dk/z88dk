; ----------------------------------------------------------------
; Z88DK INTERFACE LIBRARY FOR THE BIFROST*2 ENGINE
;
; See "bifrost2.h" for further details
; ----------------------------------------------------------------

; void BIFROST2_showTilePosH(unsigned int lin,unsigned int col)

SECTION code_clib
SECTION code_bifrost2

PUBLIC _BIFROST2_showTilePosH

EXTERN asm_BIFROST2_showTilePosH

_BIFROST2_showTilePosH:

   ld hl,2
	add hl,sp
	ld d,(hl)       ; D = lin
	inc hl
	ld e,(hl)       ; E = col

   jp asm_BIFROST2_showTilePosH
