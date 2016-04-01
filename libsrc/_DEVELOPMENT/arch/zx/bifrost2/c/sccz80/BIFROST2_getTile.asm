; ----------------------------------------------------------------
; Z88DK INTERFACE LIBRARY FOR THE BIFROST*2 ENGINE
;
; See "bifrost2.h" for further details
; ----------------------------------------------------------------

; unsigned char BIFROST2_getTile(unsigned int px,unsigned int py)

SECTION code_clib
SECTION code_bifrost2

PUBLIC BIFROST2_getTile

EXTERN asm_BIFROST2_getTile

BIFROST2_getTile:

   	ld hl,2
   	ld b,h          ; B=0
   	add hl,sp
   	ld c,(hl)       ; BC=py
   	inc hl
   	inc hl
   	ld l,(hl)       ; L=px

   	jp asm_BIFROST2_getTile
