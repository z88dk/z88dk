
; BeepFX sound effect by shiru
; http://shiru.untergrund.net

SECTION seg_rodata_sound_bit

PUBLIC _bfx_3

_bfx_3:

   ; Jump_2
   
   defb 1 ;tone
   defw 100,20,500,2,16
   defb 0
