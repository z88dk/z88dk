
SECTION code_clib
SECTION code_l

PUBLIC l_long_sbcu_exx

EXTERN error_lzc

l_long_sbcu_exx:

   ; compute unsigned a -= (unsigned b + carry)
   ; unsigned a saturates at 0
   ;
   ; enter : dehl = unsigned long b
   ;         dehl'= unsigned long a
   ;         carry
   ;
   ; exit  : dehl = a - b - carry, min 0
   ;         exx set active on exit
   ;         carry set on underflow
   ;
   ; uses  : f, (bc, de, hl) of exx set, de', hl'

   push de
   push hl
   
   exx

   pop bc                      ; bc = b.LSW
   sbc hl,bc
   ex de,hl
   
   pop bc                      ; bc = b.MSW
   sbc hl,bc
   ex de,hl
   
   ret nc
   jp error_lzc
