
; BeepFX sound effect by shiru
; http://shiru.untergrund.net

SECTION rodata_clib
SECTION rodata_sound_bit

PUBLIC _bfx_12

_bfx_12:

   ; Harsh_beep_1

   defb 1 ;tone
   defw 100,100,1000,0,32896
   defb 0
