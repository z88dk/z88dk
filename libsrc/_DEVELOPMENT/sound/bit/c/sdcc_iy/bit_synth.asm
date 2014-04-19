
; void bit_synth(int dur, int freq_1, int freq_2, int freq_3, int freq_4)

XDEF _bit_synth

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
   
   ld a,c
   
   INCLUDE "sound/bit/z80/asm_bit_synth.asm"
