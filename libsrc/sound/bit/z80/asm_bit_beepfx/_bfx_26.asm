
; BeepFX sound effect by shiru
; http://shiru.untergrund.net

SECTION rodata_clib
SECTION rodata_sound_bit

PUBLIC _bfx_26

_bfx_26:

   ; Boom_7

   defb 1 ;tone
   defw 8,400,300,65511,128
   defb 2 ;noise
   defw 6,5000,5270
   defb 0
