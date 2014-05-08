
PUBLIC l_small_lsl_dehl

l_small_lsl_dehl:

   ; logical shift left 32-bit number
   ;
   ; enter : dehl = 32-bit number
   ;            a = shift amount
   ;
   ; exit  : dehl = dehl << a
   ;
   ; uses  : af, b, de, hl

   or a
   ret z
   
   ld b,a
   ld a,e

shift_loop:

   add hl,hl
   rla
   rl d
   
   djnz shift_loop
   
   ld e,a
   ret
