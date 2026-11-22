
; BeepFX sound effect by shiru
; http://shiru.untergrund.net

SECTION rodata_clib
SECTION rodata_sound_bit

PUBLIC _bfx_17

_bfx_17:

   ; Hit_3

   defb 2 ;noise
   defw 1,1000,10
   defb 1 ;tone
   defw 20,100,400,65526,128
   defb 2 ;noise
   defw 1,2000,1
   defb 0
