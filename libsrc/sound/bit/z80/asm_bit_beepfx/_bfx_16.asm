
; BeepFX sound effect by shiru
; http://shiru.untergrund.net

SECTION rodata_clib
SECTION rodata_sound_bit

PUBLIC _bfx_16

_bfx_16:

   ; Hit_2

   defb 2 ;noise
   defw 2,2000,32776
   defb 0
