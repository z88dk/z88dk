
; BeepFX sound effect by shiru
; http://shiru.untergrund.net

SECTION rodata_clib
SECTION rodata_sound_bit

PUBLIC _bfx_45

_bfx_45:

   ; Select_6

   defb 1 ;tone
   defw 4,2000,600,65436,61504
   defb 1 ;tone
   defw 4,2000,600,65436,8
   defb 1 ;tone
   defw 4,2000,600,65436,4
   defb 0
