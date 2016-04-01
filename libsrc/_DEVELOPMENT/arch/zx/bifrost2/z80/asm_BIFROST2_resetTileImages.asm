; ----------------------------------------------------------------
; Z88DK INTERFACE LIBRARY FOR THE BIFROST*2 ENGINE
;
; See "bifrost2.h" for further details
; ----------------------------------------------------------------

SECTION code_clib
SECTION code_bifrost2

PUBLIC asm_BIFROST2_resetTileImages

asm_BIFROST2_resetTileImages:

   ; hl = void *addr

   ld (51735),hl
   ret
