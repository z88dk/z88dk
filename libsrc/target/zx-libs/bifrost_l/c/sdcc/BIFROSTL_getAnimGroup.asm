; ----------------------------------------------------------------
; Z88DK INTERFACE LIBRARY FOR THE BIFROST* ENGINE - RELEASE 1.2/L
;
; See "bifrost_l.h" for further details
; ----------------------------------------------------------------

; unsigned char BIFROSTL_getAnimGroup(unsigned char tile)

SECTION code_clib
SECTION code_bifrost_l

PUBLIC _BIFROSTL_getAnimGroup

EXTERN asm_BIFROSTL_getAnimGroup

_BIFROSTL_getAnimGroup:

   ld hl,2
	add hl,sp
	ld l,(hl)
	
	jp asm_BIFROSTL_getAnimGroup
