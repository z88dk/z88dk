
; BeepFX sound effect by shiru
; http://shiru.untergrund.net

SECTION rodata_clib
SECTION rodata_sound_bit

PUBLIC _bfx_25

_bfx_25:

   ; Boom_6

   defb 2 ;noise
   defw 5,1000,5130
   defb 1 ;tone
   defw 20,100,200,65526,128
   defb 2 ;noise
   defw 1,10000,200
   defb 0
