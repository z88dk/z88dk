
; void bit_synth_di_callee(int dur, int freq_1, int freq_2, int freq_3, int freq_4)

XDEF bit_synth_di_callee

bit_synth_di_callee:

   pop af
   pop de
   pop bc
   ld d,c
   pop hl
   pop bc
   ld h,c
   pop bc
   push af
   
   ld a,c

   INCLUDE "sound/bit/z80/asm_bit_synth_di.asm"
