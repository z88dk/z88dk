
; BeepFX sound effect by shiru
; http://shiru.untergrund.net

SECTION rodata_clib
SECTION rodata_sound_bit

PUBLIC _bfx_48

_bfx_48:

   ; Alarm_2

   defb 1 ;tone
   defw 32,1000,2000,16384,320
   defb 0
