
; ===============================================================
; 2011-2012 Shiru http://shiru.untergrund.net
; 2014 adapted to z88dk by aralbrec
; ===============================================================
;
; void bit_beepfx_di(void *effect)
;
; Plays the selected sound effect on the one bit device.
;
; ===============================================================

SECTION code_clib
SECTION code_sound_bit

PUBLIC asm_bit_beepfx_di

EXTERN asm_bit_beepfx, asm_z80_push_di, asm0_z80_pop_ei

asm_bit_beepfx_di:

   ; enter : ix = void *effect
   ;
   ; uses  : af, bc, de, hl, bc', de', hl', ix

   call asm_z80_push_di
   call asm_bit_beepfx
   jp asm0_z80_pop_ei
