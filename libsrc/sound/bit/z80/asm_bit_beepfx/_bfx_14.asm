
; BeepFX sound effect by shiru
; http://shiru.untergrund.net

SECTION rodata_clib
SECTION rodata_sound_bit

PUBLIC _bfx_14

_bfx_14:

   ; Harsh_beep_3

   defb 1 ;tone
   defw 100,100,1000,0,32640
   defb 0
