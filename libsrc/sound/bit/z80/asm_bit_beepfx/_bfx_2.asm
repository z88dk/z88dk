
; BeepFX sound effect by shiru
; http://shiru.untergrund.net

SECTION rodata_clib
SECTION rodata_sound_bit

PUBLIC _bfx_2

_bfx_2:

   ; Jump_1
   
   defb 1 ;tone
   defw 100,20,500,2,128
   defb 0
