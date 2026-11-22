
; BeepFX sound effect by shiru
; http://shiru.untergrund.net

SECTION rodata_clib
SECTION rodata_sound_bit

PUBLIC _bfx_10

_bfx_10:

   ; Fat_beep_2

   defb 1 ;tone
   defw 400,50,200,0,63104
   defb 0
