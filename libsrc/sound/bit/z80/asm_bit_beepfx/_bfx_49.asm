
; BeepFX sound effect by shiru
; http://shiru.untergrund.net

SECTION rodata_clib
SECTION rodata_sound_bit

PUBLIC _bfx_49

_bfx_49:

   ; Alarm_3

   defb 1 ;tone
   defw 200,20,400,0,384
   defb 1 ;tone
   defw 200,20,800,0,384
   defb 1 ;tone
   defw 200,20,400,0,384
   defb 1 ;tone
   defw 200,20,800,0,384
   defb 1 ;tone
   defw 200,20,400,0,384
   defb 1 ;tone
   defw 200,20,800,0,384
   defb 0
