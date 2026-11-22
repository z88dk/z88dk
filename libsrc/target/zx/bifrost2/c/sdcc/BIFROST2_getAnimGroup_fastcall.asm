; ----------------------------------------------------------------
; Z88DK INTERFACE LIBRARY FOR THE BIFROST*2 ENGINE
;
; See "bifrost2.h" for further details
; ----------------------------------------------------------------

; unsigned char BIFROST2_getAnimGroup(unsigned char tile)
; fastcall

SECTION code_clib
SECTION code_bifrost2

PUBLIC _BIFROST2_getAnimGroup_fastcall

EXTERN asm_BIFROST2_getAnimGroup

defc _BIFROST2_getAnimGroup_fastcall = asm_BIFROST2_getAnimGroup
