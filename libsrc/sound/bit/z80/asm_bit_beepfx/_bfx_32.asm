
; BeepFX sound effect by shiru
; http://shiru.untergrund.net

SECTION rodata_clib
SECTION rodata_sound_bit

PUBLIC _bfx_32

_bfx_32:

   ; Item_5

   defb 1 ;tone
   defw 1,1000,1000,0,128
   defb 1 ;pause
   defw 1,1000,0,0,0
   defb 1 ;tone
   defw 1,2000,2000,0,128
   defb 1 ;tone
   defw 1,2000,2000,0,16
   defb 0
