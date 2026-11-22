
; BeepFX sound effect by shiru
; http://shiru.untergrund.net

SECTION rodata_clib
SECTION rodata_sound_bit

PUBLIC _bfx_55

_bfx_55:

   ; Old_computer

   defb 1 ;tone
   defw 40,2125,16384,45459,128
   defb 0
