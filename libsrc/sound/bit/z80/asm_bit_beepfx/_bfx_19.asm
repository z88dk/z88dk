
; BeepFX sound effect by shiru
; http://shiru.untergrund.net

SECTION rodata_clib
SECTION rodata_sound_bit

PUBLIC _bfx_19

_bfx_19:

   ; Jet_burst

   defb 2 ;noise
   defw 20,2000,1290
   defb 0
