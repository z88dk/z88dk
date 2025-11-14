
; BeepFX sound effect by shiru
; http://shiru.untergrund.net

SECTION rodata_clib
SECTION rodata_sound_bit

PUBLIC _bfx_7

_bfx_7:

   ; Grab_1

   defb 2 ;noise
   defw 1,1000,10
   defb 2 ;noise
   defw 1,1000,1
   defb 0
