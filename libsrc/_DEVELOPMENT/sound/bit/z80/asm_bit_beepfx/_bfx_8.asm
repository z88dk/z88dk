
; BeepFX sound effect by shiru
; http://shiru.untergrund.net

SECTION rodata_clib
SECTION rodata_sound_bit

PUBLIC _bfx_8

_bfx_8:

   ; Grab_2

   defb 2 ;noise
   defw 1,1000,20
   defb 1 ;pause
   defw 1,1000,0,0,0
   defb 2 ;noise
   defw 1,1000,1
   defb 0
