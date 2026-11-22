
; BeepFX sound effect by shiru
; http://shiru.untergrund.net

SECTION rodata_clib
SECTION rodata_sound_bit

PUBLIC _bfx_4

_bfx_4:

   ; Pick

   defb 1 ;tone
   defw 10,100,2000,100,128
   defb 0
