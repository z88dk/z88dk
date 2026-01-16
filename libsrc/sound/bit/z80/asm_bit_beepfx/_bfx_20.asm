
; BeepFX sound effect by shiru
; http://shiru.untergrund.net

SECTION rodata_clib
SECTION rodata_sound_bit

PUBLIC _bfx_20

_bfx_20:

   ; Boom_1

   defb 2 ;noise
   defw 100,400,2562
   defb 0
