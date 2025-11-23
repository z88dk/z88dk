
; BeepFX sound effect by shiru
; http://shiru.untergrund.net

SECTION rodata_clib
SECTION rodata_sound_bit

PUBLIC _bfx_53

_bfx_53:

   ; Nope

   defb 1 ;tone
   defw 10,1000,200,2,272
   defb 1 ;pause
   defw 1,4000,0,0,0
   defb 1 ;tone
   defw 10,1000,200,65534,272
   defb 0
