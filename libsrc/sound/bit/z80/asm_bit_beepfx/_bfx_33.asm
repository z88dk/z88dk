
; BeepFX sound effect by shiru
; http://shiru.untergrund.net

SECTION rodata_clib
SECTION rodata_sound_bit

PUBLIC _bfx_33

_bfx_33:

   ; Item_6

   defb 1 ;tone
   defw 1,1000,2000,0,64
   defb 1 ;pause
   defw 1,1000,0,0,0
   defb 1 ;tone
   defw 1,1000,1500,0,64
   defb 0
