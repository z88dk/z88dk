
; BeepFX sound effect by shiru
; http://shiru.untergrund.net

SECTION rodata_clib
SECTION rodata_sound_bit

PUBLIC _bfx_9

_bfx_9:

   ; Fat_beep_1

   defb 1 ;tone
   defw 20,1000,200,0,63104
   defb 0
