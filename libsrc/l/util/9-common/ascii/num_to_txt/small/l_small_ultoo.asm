
SECTION code_clib
SECTION code_l

PUBLIC l_small_ultoo

EXTERN l2_small_utoo_lz, l2_small_utoo_nlz
EXTERN l3_small_utoo_lz, l3_small_utoo_nlz

l_small_ultoo:

   ; write unsigned octal long to ascii buffer
   ;
   ; enter : dehl = unsigned long
   ;           bc = char *buffer
   ;         carry set to write leading zeroes
   ;
   ; exit  : de   = char *buffer (one byte past last char written)
   ;         carry set if in write loop
   ;
   ; uses  : af, bc, de, hl

   push hl
   ex de,hl
   
   ld e,c
   ld d,b
   
   ld c,l
   ld b,5
   
   ld a,0
   call c, l2_small_utoo_lz
   call nc, l2_small_utoo_nlz

   pop hl
   ld b,6

   jr c, leading_zeroes

no_leading_zeroes:

   ld a,c
   and $03

   dec de
   jp l3_small_utoo_nlz

leading_zeroes:

   ld a,c
   and $03
   
   jp l3_small_utoo_lz
