
; void bit_synth_di(int dur, int freq_1, int freq_2, int freq_3, int freq_4)

SECTION code_clib
SECTION code_sound_bit

PUBLIC bit_synth_di

EXTERN asm_bit_synth_di

bit_synth_di:

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
   
   ld a,c
   jp asm_bit_synth_di
