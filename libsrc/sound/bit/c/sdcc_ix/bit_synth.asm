
; void bit_synth(int dur, int freq_1, int freq_2, int freq_3, int freq_4)

SECTION code_clib
SECTION smc_sound_bit

PUBLIC _bit_synth

EXTERN l0_bit_synth_callee

_bit_synth:

   pop af
   pop de
   pop bc
   ld d,c
   pop hl
   pop bc
   ld h,c
   pop bc
   
   push bc
   push bc
   push hl
   push bc
   push de
   push af

   jp l0_bit_synth_callee
