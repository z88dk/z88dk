
; BeepFX sound effect by shiru
; http://shiru.untergrund.net

SECTION rodata_clib
SECTION rodata_sound_bit

PUBLIC _bfx_23

_bfx_23:

   ; Boom_4

   defb 2 ;noise
   defw 25,2500,28288
   defb 0
