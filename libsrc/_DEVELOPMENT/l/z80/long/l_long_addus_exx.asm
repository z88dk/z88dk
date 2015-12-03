
SECTION code_clib
SECTION code_l

PUBLIC l_long_addus_exx

EXTERN l_long_addu_exx, l_long_sbcu_exx, l_neg_dehl

l_long_addus_exx:

   ; compute unsigned a += signed b
   ; unsigned a saturates at 0 or $ffff ffff
   ;
   ; enter : dehl'= unsigned long a
   ;         dehl = signed long b
   ;
   ; exit  : dehl = a + b, max $ ffff ffff, min 0
   ;         exx set active on exit
   ;         carry set on overflow or underflow
   ;
   ; uses  : f, (bc, de, hl) of exx set, de', hl'

   bit 7,d
   jp z, l_long_addu_exx       ; if signed b is positive

   call l_neg_dehl
   
   or a
   jp l_long_sbcu_exx
