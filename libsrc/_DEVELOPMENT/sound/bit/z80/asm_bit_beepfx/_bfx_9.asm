
; BeepFX sound effect by shiru
; http://shiru.untergrund.net

PUBLIC _bfx_9

_bfx_9:

   ; Fat_beep_1

   defb 1 ;tone
   defw 20,1000,200,0,63104
   defb 0
