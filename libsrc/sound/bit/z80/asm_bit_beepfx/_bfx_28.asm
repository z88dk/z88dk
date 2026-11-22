
; BeepFX sound effect by shiru
; http://shiru.untergrund.net

SECTION rodata_clib
SECTION rodata_sound_bit

PUBLIC _bfx_28

_bfx_28:

   ; Item_1

   defb 1 ;tone
   defw 10,400,1000,65136,2688
   defb 0
