
; void bit_synth_callee(int dur, int freq_1, int freq_2, int freq_3, int freq_4)

SECTION code_clib
SECTION smc_sound_bit

PUBLIC _bit_synth_callee, l0_bit_synth_callee

EXTERN asm_bit_synth

_bit_synth_callee:

   pop af
   pop de
   pop bc
   ld d,c
   pop hl
   pop bc
   ld h,c
   pop bc
   push af

l0_bit_synth_callee:

   ld a,c
   
   jp asm_bit_synth
