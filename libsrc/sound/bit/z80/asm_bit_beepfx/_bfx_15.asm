
; BeepFX sound effect by shiru
; http://shiru.untergrund.net

SECTION rodata_clib
SECTION rodata_sound_bit

PUBLIC _bfx_15

_bfx_15:

   ; Hit_1

   defb 1 ;tone
   defw 100,20,400,1,25728
   defb 0
