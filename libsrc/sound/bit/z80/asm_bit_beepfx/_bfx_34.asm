
; BeepFX sound effect by shiru
; http://shiru.untergrund.net

SECTION rodata_clib
SECTION rodata_sound_bit

PUBLIC _bfx_34

_bfx_34:

   ; Switch_1

   defb 2 ;noise
   defw 1,1000,4
   defb 1 ;tone
   defw 1,1000,2000,0,128
   defb 0
