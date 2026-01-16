
; BeepFX sound effect by shiru
; http://shiru.untergrund.net

SECTION rodata_clib
SECTION rodata_sound_bit

PUBLIC _bfx_54

_bfx_54:

   ; Uh-huh ?

   defb 1 ;tone
   defw 20,500,200,5,272
   defb 1 ;pause
   defw 1,1000,0,0,0
   defb 1 ;tone
   defw 30,500,200,8,272
   defb 0
