
; void bit_beep(uint16_t duration_ms, uint16_t frequency_hz)

SECTION code_clib
SECTION code_sound_bit

PUBLIC _bit_beep

EXTERN asm_bit_beep

_bit_beep:

   pop af
   pop de
   pop hl
   
   push hl
   push de
   push af
   
   jp asm_bit_beep
