
; BeepFX sound effect by shiru
; http://shiru.untergrund.net

SECTION rodata_clib
SECTION rodata_sound_bit

PUBLIC _bfx_31

_bfx_31:

   ; Item_4

   defb 1 ;tone
   defw 4,1000,1000,65136,128
   defb 0
