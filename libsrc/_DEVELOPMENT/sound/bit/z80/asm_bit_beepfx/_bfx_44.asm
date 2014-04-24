
; BeepFX sound effect by shiru
; http://shiru.untergrund.net

XLIB _bfx_44

_bfx_44:

   ; Select_5

   defb 1 ;tone
   defw 4,1000,400,100,128
   defb 1 ;tone
   defw 4,1000,400,100,64
   defb 1 ;tone
   defw 4,1000,400,100,32
   defb 1 ;tone
   defw 4,1000,400,100,16
   defb 0
