; ----------------------------------------------------------------
; Z88DK INTERFACE LIBRARY FOR THE BIFROST* ENGINE - RELEASE 1.2/L
;
; See "bifrost_h.h" for further details
; ----------------------------------------------------------------

; void BIFROSTH_drawBackTilesH(unsigned int lin,unsigned int col,unsigned int attr)

SECTION code_clib
SECTION code_bifrost_h

PUBLIC BIFROSTH_drawBackTilesH

EXTERN asm_BIFROSTH_drawBackTilesH

BIFROSTH_drawBackTilesH:

   	ld hl,2
   	add hl,sp
   	ld c,(hl)       ; C=attrib
   	inc hl
   	inc hl
   	ld e,(hl)       ; E=col
   	inc hl
   	inc hl
   	ld d,(hl)       ; D=lin

   	jp asm_BIFROSTH_drawBackTilesH        ; execute 'draw_back_tiles'
