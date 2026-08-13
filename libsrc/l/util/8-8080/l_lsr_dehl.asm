
SECTION code_clib
SECTION code_l

PUBLIC l_lsr_dehl

EXTERN error_lznc

l_lsr_dehl:
   ; logical shift right 32-bit unsigned long
   ;
   ; enter : dehl = 32-bit number
   ;            a = shift amount
   ;
   ; exit  : dehl = dehl >> a
   ;
   ; uses  : af, b, de, hl

   or       a
   ret      z
   
   cp       32
   jp       nc, error_lznc
   
   ld       b,a

shift_loop:
    or      a
    ld      a,d
    rra
    ld      d,a
    ld      a,e
    rra
    ld      e,a
    ld      a,h
    rra
    ld      h,a
    ld      a,l
    rra
    ld      l,a
    djnz    shift_loop
    ret
