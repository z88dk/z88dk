
; BeepFX sound effect by shiru
; http://shiru.untergrund.net

SECTION rodata_clib
SECTION rodata_sound_bit

PUBLIC _bfx_50

_bfx_50:

   ; Eat

   defb 1 ;tone
   defw 20,100,200,10,1025
   defb 1 ;pause
   defw 30,100,0,0,0
   defb 1 ;tone
   defw 50,100,200,10,1025
   defb 0
