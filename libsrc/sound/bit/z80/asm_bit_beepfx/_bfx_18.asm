
; BeepFX sound effect by shiru
; http://shiru.untergrund.net

SECTION rodata_clib
SECTION rodata_sound_bit

PUBLIC _bfx_18

_bfx_18:

   ; Hit_4

   defb 1 ;tone
   defw 100,20,1000,65535,2176
   defb 0
