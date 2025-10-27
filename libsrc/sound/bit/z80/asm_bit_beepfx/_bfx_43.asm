
; BeepFX sound effect by shiru
; http://shiru.untergrund.net

SECTION rodata_clib
SECTION rodata_sound_bit

PUBLIC _bfx_43

_bfx_43:

   ; Select_4

   defb 1 ;tone
   defw 5,2000,200,100,128
   defb 0
