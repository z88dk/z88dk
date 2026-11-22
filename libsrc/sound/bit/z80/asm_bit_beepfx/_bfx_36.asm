
; BeepFX sound effect by shiru
; http://shiru.untergrund.net

SECTION rodata_clib
SECTION rodata_sound_bit

PUBLIC _bfx_36

_bfx_36:

   ; Power_off

   defb 1 ;tone
   defw 10,400,400,65516,128
   defb 1 ;pause
   defw 10,400,0,0,0
   defb 1 ;tone
   defw 10,400,350,65516,96
   defb 1 ;pause
   defw 10,400,0,0,0
   defb 1 ;tone
   defw 10,400,300,65516,64
   defb 1 ;pause
   defw 10,400,0,0,0
   defb 1 ;tone 
   defw 10,400,250,65516,32
   defb 1 ;pause
   defw 10,400,0,0,0
   defb 1 ;tone
   defw 10,400,200,65516,16
   defb 0
