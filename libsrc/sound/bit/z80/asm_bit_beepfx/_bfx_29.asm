
; BeepFX sound effect by shiru
; http://shiru.untergrund.net

SECTION rodata_clib
SECTION rodata_sound_bit

PUBLIC _bfx_29

_bfx_29:

   ; Item_2

   defb 1 ;tone
   defw 10,400,1000,65336,2688
   defb 0
