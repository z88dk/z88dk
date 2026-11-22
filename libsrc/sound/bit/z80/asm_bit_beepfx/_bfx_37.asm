
; BeepFX sound effect by shiru
; http://shiru.untergrund.net

SECTION rodata_clib
SECTION rodata_sound_bit

PUBLIC _bfx_37

_bfx_37:

   ; Score

   defb 1 ;tone
   defw 5,1800,1000,1000,65408
   defb 0
