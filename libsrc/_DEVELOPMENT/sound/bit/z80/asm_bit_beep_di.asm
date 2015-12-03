
; ===============================================================
; 2014
; ===============================================================
;
; void bit_beep_di(uint16_t duration_ms, uint16_t frequency_hz)
;
; As bit_beep() but interrupts are disabled around the tone.
; Proper interrupt status is restored prior to return.
;
; ===============================================================

SECTION code_clib
SECTION code_sound_bit

PUBLIC asm_bit_beep_di

EXTERN asm_bit_beep, asm_z80_push_di, asm0_z80_pop_ei

asm_bit_beep_di:

   ; enter : hl = note_frequency
   ;         de = duration_ms
   ;
   ; uses  : af, bc, de, hl, (bc', de', hl', ix for integer division)

   call asm_z80_push_di
   call asm_bit_beep
   jp asm0_z80_pop_ei
