; ----------------------------------------------------------------
; Z88DK INTERFACE LIBRARY FOR THE BIFROST* ENGINE - RELEASE 1.2/L
;
; See "bifrost_h.h" for further details
; ----------------------------------------------------------------

; unsigned char BIFROSTH_getTile(unsigned int px,unsigned int py)

SECTION code_clib
SECTION code_bifrost_h

PUBLIC BIFROSTH_getTile

EXTERN asm_BIFROSTH_getTile

BIFROSTH_getTile:

   	ld hl,2
   	add hl,sp
   	ld c,(hl)       ; C=py
   	inc hl
   	inc hl
   	ld l,(hl)       ; L=px

   	jp asm_BIFROSTH_getTile
