
; ===============================================================
; 2014
; ===============================================================
;
; char *bit_play_di(char *melody)
;
; As bit_play() but interrupts are disabled around the melody.
; Proper interrupt status is restored prior to return.
;
; ===============================================================

SECTION code_clib
SECTION code_sound_bit

PUBLIC asm_bit_play_di

EXTERN asm_bit_play, asm_z80_push_di, asm0_z80_pop_ei

asm_bit_play_di:

   ; enter : hl = char *melody
   ;
   ; exit  : success
   ;
   ;            hl = 0
   ;            de = ptr to '\0' in melody
   ;            carry reset
   ;
   ;         fail (error in melody string)
   ;
   ;            hl = ptr to unrecognized note
   ;            carry set, errno = einval
   ;               
   ; uses  : af, bc, de, hl, (bc', de', hl', ix for integer division)

   call asm_z80_push_di
   call asm_bit_play
   jp asm0_z80_pop_ei
