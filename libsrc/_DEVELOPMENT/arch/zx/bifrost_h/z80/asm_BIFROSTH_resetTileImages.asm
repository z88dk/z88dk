; ----------------------------------------------------------------
; Z88DK INTERFACE LIBRARY FOR THE BIFROST* ENGINE - RELEASE 1.2/L
;
; See "bifrost_h.h" for further details
; ----------------------------------------------------------------

SECTION code_clib
SECTION code_bifrost_h

PUBLIC asm_BIFROSTH_resetTileImages

asm_BIFROSTH_resetTileImages:

   ; hl = void *addr

   ld (58726),hl
   ret
