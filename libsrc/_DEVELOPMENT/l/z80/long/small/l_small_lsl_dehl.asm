
SECTION code_clib
SECTION code_l

PUBLIC l_small_lsl_dehl

EXTERN error_lznc

l_small_lsl_dehl:

   ; logical shift left 32-bit number
   ;
   ; enter : dehl = 32-bit number
   ;            a = shift amount
   ;
   ; exit  : dehl = dehl << a
   ;
   ; uses  : af, b, de, hl

   and 31
   ret z
   
   cp 32
   jp nc, error_lznc
   
   ld b,a
   ld a,e

shift_loop:

   add hl,hl
   rla
   rl d
   
   djnz shift_loop
   
   ld e,a
   ret
