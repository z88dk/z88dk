
; BeepFX sound effect by shiru
; http://shiru.untergrund.net

PUBLIC _bfx_48

_bfx_48:

   ; Alarm_2

   defb 1 ;tone
   defw 32,1000,2000,16384,320
   defb 0
