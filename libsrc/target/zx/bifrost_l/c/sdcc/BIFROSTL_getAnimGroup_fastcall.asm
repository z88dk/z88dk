; ----------------------------------------------------------------
; Z88DK INTERFACE LIBRARY FOR THE BIFROST* ENGINE - RELEASE 1.2/L
;
; See "bifrost_l.h" for further details
; ----------------------------------------------------------------

; unsigned char BIFROSTL_getAnimGroup(unsigned char tile)
; fastcall

SECTION code_clib
SECTION code_bifrost_l

PUBLIC _BIFROSTL_getAnimGroup_fastcall

EXTERN asm_BIFROSTL_getAnimGroup

defc _BIFROSTL_getAnimGroup_fastcall = asm_BIFROSTL_getAnimGroup
