
; ===============================================================
; Mar 2011 Shiru (shiru@mail.ru) 03'11
;
; 2014 adapted to z88dk by aralbrec
; * modified to use 1-bit output for all targets
; ===============================================================
;
; void *bit_play_tritone_di(void *song)
;
; ===============================================================

SECTION code_clib
SECTION code_sound_bit

PUBLIC asm_bit_play_tritone_di

EXTERN asm_bit_play_tritone, asm_z80_push_di, asm0_z80_pop_ei

asm_bit_play_tritone_di:

   ; enter : hl = song address
   ;            = 0 continue after loop command
   ;            =-1 continue after end of row reached
   ;
   ; exit  : hl = 0 if loop command met
   ;             -1 if one row of song has played
   ;
   ; uses  : all except af', iy

   call asm_z80_push_di
   call asm_bit_play_tritone
   jp asm0_z80_pop_ei
