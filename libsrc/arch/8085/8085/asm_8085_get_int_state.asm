;
; Copyright (c) November 2026 Phillip Stevens (feilipu), MIT.
;
; unsigned char z80_get_int_state(void)
;
; Retrieve the current ei/di status.
;
; ===============================================================

SECTION code_clib
SECTION code_z80

PUBLIC asm_z80_get_int_state
PUBLIC asm_cpu_get_int_state

asm_z80_get_int_state:
asm_cpu_get_int_state:

   ; RIM bit 3 is IE. Return that byte in L.
   ; push af / pop hl would leave the flags in L and the RIM byte in H.
   ;
   ; exit  : l = ei/di status
   ;
   ; uses  : af, hl

   rim
   ld l,a
   ld h,0
   ret
