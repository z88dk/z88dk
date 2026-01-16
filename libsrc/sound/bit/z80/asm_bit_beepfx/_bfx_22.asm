
; BeepFX sound effect by shiru
; http://shiru.untergrund.net

SECTION rodata_clib
SECTION rodata_sound_bit

PUBLIC _bfx_22

_bfx_22:

   ; Boom_3

   defb 2 ;noise
   defw 8,200,20
   defb 2 ;noise
   defw 4,2000,5220
   defb 0
