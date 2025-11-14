
; BeepFX sound effect by shiru
; http://shiru.untergrund.net

SECTION rodata_clib
SECTION rodata_sound_bit

PUBLIC _bfx_13

_bfx_13:

   ; Harsh_beep_2

   defb 1 ;tone
   defw 1000,10,100,0,25728
   defb 0
