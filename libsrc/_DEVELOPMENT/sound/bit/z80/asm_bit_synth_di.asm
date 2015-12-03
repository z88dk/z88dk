
; ===============================================================
; 2008 Stefano Bodrato
; ===============================================================
;
; void bit_synth_di(int dur, int freq_1, int freq_2, int freq_3, int freq_4)
;
; As bit_synth() but interrupts are disabled around the melody.
; Proper interrupt status is restored prior to return.
;
; ===============================================================

SECTION code_clib
SECTION code_sound_bit

PUBLIC asm_bit_synth_di

EXTERN asm_bit_synth, asm_z80_push_di, asm0_z80_pop_ei

asm_bit_synth_di:

   ; enter :  a = duration
   ;          h = frequency_1 (0 = disable voice)
   ;          l = frequency_2 (0 = disable voice)
   ;          d = frequency_3 (0 = disable voice)
   ;          e = frequency_4 (0 = disable voice)
   ;
   ; uses  : af, bc, de, hl, (bc' if port_16)

   call asm_z80_push_di
   call asm_bit_synth
   jp asm0_z80_pop_ei
