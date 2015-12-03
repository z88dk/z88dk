
; BeepFX sound effect by shiru
; http://shiru.untergrund.net

SECTION rodata_clib
SECTION rodata_sound_bit

PUBLIC _bfx_27

_bfx_27:

   ; Boom_8

   defb 2 ;noise
   defw 1,1000,4
   defb 1 ;tone
   defw 4,1000,400,65436,128
   defb 2 ;noise
   defw 1,5000,150
   defb 0
