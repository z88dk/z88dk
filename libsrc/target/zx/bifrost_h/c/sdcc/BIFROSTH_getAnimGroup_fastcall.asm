; ----------------------------------------------------------------
; Z88DK INTERFACE LIBRARY FOR THE BIFROST* ENGINE - RELEASE 1.2/L
;
; See "bifrost_h.h" for further details
; ----------------------------------------------------------------

; unsigned char BIFROSTH_getAnimGroup(unsigned char tile)
; fastcall

SECTION code_clib
SECTION code_bifrost_h

PUBLIC _BIFROSTH_getAnimGroup_fastcall

EXTERN asm_BIFROSTH_getAnimGroup

defc _BIFROSTH_getAnimGroup_fastcall = asm_BIFROSTH_getAnimGroup
