
; BeepFX sound effect by shiru
; http://shiru.untergrund.net

SECTION rodata_clib
SECTION rodata_sound_bit

PUBLIC _bfx_46

_bfx_46:

   ; Select_7

   defb 1 ;tone
   defw 2,4000,400,200,64
   defb 1 ;tone
   defw 2,4000,200,200,32
   defb 0
