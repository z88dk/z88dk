
; void bit_synth_di(int dur, int freq_1, int freq_2, int freq_3, int freq_4)

PUBLIC _bit_synth_di

_bit_synth_di:

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
   
   INCLUDE "sound/bit/z80/asm_bit_synth_di.asm"
