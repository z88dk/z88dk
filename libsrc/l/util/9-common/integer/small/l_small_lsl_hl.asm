
SECTION code_clib
SECTION code_l

EXTERN error_znc

PUBLIC l_small_lsl_hl

l_small_lsl_hl:

   ; logical shift left 16-bit number
   ;
   ; enter : hl = 16-bit number
   ;          a = shift amount
   ;
   ; exit  : hl = hl << a
   ;
   ; uses  : af, b, hl

   or a
   ret z
   
   cp 16
   jp nc, error_znc
   
   ld b,a

shift_loop:

   add hl,hl
   djnz shift_loop
   
   ret
