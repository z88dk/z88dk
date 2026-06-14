
SECTION code_clib
SECTION code_l

PUBLIC l_lsl_dehl

EXTERN error_lznc

l_lsl_dehl:

   ; logical shift left 32-bit number
   ;
   ; enter : dehl = 32-bit number
   ;            a = shift amount
   ;
   ; exit  : dehl = dehl << a
   ;
   ; uses  : af, b, de, hl

   or       a
   ret      z
   
   cp       32
   jp       nc, error_lznc
   
   ld       b,a

shift_loop:

   add      hl,hl
   ld       a,e
   rla
   ld       e,a
   ld       a,d 
   rla
   ld       d,a
   
   djnz     shift_loop
   ret
