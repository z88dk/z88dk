
; BeepFX sound effect by shiru
; http://shiru.untergrund.net

SECTION rodata_clib
SECTION rodata_sound_bit

PUBLIC _bfx_52

_bfx_52:

   ; Roboblip

   defb 1 ;tone
   defw 1,2000,200,0,128
   defb 1 ;pause
   defw 1,2000,0,0,0
   defb 1 ;tone
   defw 1,2000,200,0,32
   defb 1 ;pause
   defw 1,2000,0,0,0
   defb 1 ;tone
   defw 1,2000,200,0,16
   defb 1 ;pause
   defw 1,2000,0,0,0
   defb 1 ;tone
   defw 1,2000,200,0,8
   defb 0
