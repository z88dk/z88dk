
; BeepFX sound effect by shiru
; http://shiru.untergrund.net

SECTION rodata_clib
SECTION rodata_sound_bit

PUBLIC _bfx_6

_bfx_6:

   ; Drop_2

   defb 2 ;noise
   defw 100,50,356
   defb 0
