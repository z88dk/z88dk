
; BeepFX sound effect by shiru
; http://shiru.untergrund.net

SECTION rodata_clib
SECTION rodata_sound_bit

PUBLIC _bfx_40

_bfx_40:

   ; Select_1

   defb 1 ;tone
   defw 1,2000,400,0,128
   defb 1 ;tone
   defw 1,2000,400,0,16
   defb 1 ;tone
   defw 1,2000,600,0,128
   defb 1 ;tone
   defw 1,2000,600,0,16
   defb 1 ;tone
   defw 1,2000,800,0,128
   defb 1 ;tone
   defw 1,2000,800,0,16
   defb 0
