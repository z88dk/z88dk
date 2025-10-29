
; BeepFX sound effect by shiru
; http://shiru.untergrund.net

SECTION rodata_clib
SECTION rodata_sound_bit

PUBLIC _bfx_11

_bfx_11:

   ; Fat_beep_3

   defb 1 ;tone
   defw 2000,10,400,0,63104
   defb 0
