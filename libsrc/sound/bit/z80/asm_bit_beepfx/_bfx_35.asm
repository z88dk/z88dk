
; BeepFX sound effect by shiru
; http://shiru.untergrund.net

SECTION rodata_clib
SECTION rodata_sound_bit

PUBLIC _bfx_35

_bfx_35:

   ; Switch_2

   defb 2 ;noise
   defw 1,1000,8
   defb 1 ;tone
   defw 1,1000,800,0,128
   defb 2 ;noise
   defw 1,1000,16
   defb 1 ;tone
   defw 1,1000,700,0,128
   defb 0
