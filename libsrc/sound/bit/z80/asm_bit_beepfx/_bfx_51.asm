
; BeepFX sound effect by shiru
; http://shiru.untergrund.net

SECTION rodata_clib
SECTION rodata_sound_bit

PUBLIC _bfx_51

_bfx_51:

   ; Gulp

   defb 1 ;tone
   defw 50,200,500,65516,128
   defb 0
