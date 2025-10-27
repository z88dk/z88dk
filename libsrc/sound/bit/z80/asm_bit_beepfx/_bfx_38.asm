
; BeepFX sound effect by shiru
; http://shiru.untergrund.net

SECTION rodata_clib
SECTION rodata_sound_bit

PUBLIC _bfx_38

_bfx_38:

   ; Clang

   defb 1 ;tone
   defw 3500,10,2,0,25728
   defb 0
