
; BeepFX sound effect by shiru
; http://shiru.untergrund.net

SECTION rodata_clib
SECTION rodata_sound_bit

PUBLIC _bfx_30

_bfx_30:

   ; Item_3

   defb 1 ;tone
   defw 4,1000,1000,400,128
   defb 0
