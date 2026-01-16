
; BeepFX sound effect by shiru
; http://shiru.untergrund.net

SECTION rodata_clib
SECTION rodata_sound_bit

PUBLIC _bfx_21

_bfx_21:

   ; Boom_2

   defb 2 ;noise
   defw 5,1000,5124
   defb 1 ;tone
   defw 50,100,200,65534,128
   defb 0
