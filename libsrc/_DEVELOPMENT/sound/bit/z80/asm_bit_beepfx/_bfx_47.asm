
; BeepFX sound effect by shiru
; http://shiru.untergrund.net

XLIB _bfx_47

_bfx_47:

   ; Alarm_1

   defb 1 ;tone
   defw 2,1000,400,100,64
   defb 1 ;tone
   defw 2,1000,400,100,64
   defb 1 ;tone
   defw 2,1000,400,100,64
   defb 1 ;tone
   defw 2,1000,400,100,64
   defb 0
