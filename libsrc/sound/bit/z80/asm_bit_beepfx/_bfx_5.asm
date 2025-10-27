
; BeepFX sound effect by shiru
; http://shiru.untergrund.net

SECTION rodata_clib
SECTION rodata_sound_bit

PUBLIC _bfx_5

_bfx_5:

   ; Drop_1

   defb 1 ;tone
   defw 50,100,200,65531,128
   defb 0
