
; BeepFX sound effect by shiru
; http://shiru.untergrund.net

SECTION rodata_clib
SECTION rodata_sound_bit

PUBLIC _bfx_24

_bfx_24:

   ; Boom_5

   defb 2 ;noise
   defw 100,40,20
   defb 1 ;tone
   defw 100,40,400,65532,128
   defb 2 ;noise
   defw 100,40,40
   defb 1 ;tone
   defw 100,40,350,65532,128
   defb 2 ;noise
   defw 100,40,80
   defb 1 ;tone
   defw 100,40,320,65532,128
   defb 2 ;noise
   defw 100,40,100
   defb 1 ;tone
   defw 100,40,310,65532,128
   defb 2 ;noise
   defw 100,40,120
   defb 1 ;tone
   defw 100,40,300,65532,128
   defb 0
