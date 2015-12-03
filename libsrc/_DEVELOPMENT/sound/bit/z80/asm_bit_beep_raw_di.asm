
; ===============================================================
; 2014
; ===============================================================
;
; void bit_beep_raw_di(uint_16t num_cycles, uint16_t tone_period_T)
;
; As bit_beep_raw() but interrupts are disabled around the tone.
; Proper interrupt status is restored prior to return.
;
; ===============================================================

SECTION code_clib
SECTION code_sound_bit

PUBLIC asm_bit_beep_raw_di

EXTERN asm_bit_beep_raw, asm_z80_push_di, asm0_z80_pop_ei

asm_bit_beep_raw_di:

   ; enter : hl = (tone_period - 236) / 8, tone_period in z80 T states
   ;         de = duration in number of cycles of tone = time (sec) * freq (Hz)
   ;
   ; uses  : af, bc, de, hl, ix
   
   call asm_z80_push_di
   call asm_bit_beep_raw
   jp asm0_z80_pop_ei
