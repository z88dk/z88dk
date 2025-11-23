
SECTION code_clib
SECTION code_l

PUBLIC l_long_cmpu_mde_mhl

l_long_cmpu_mde_mhl:

   ; comparison of two unsigned longs stored in memory
   ;
   ; enter : de = unsigned long *a
   ;         hl = unsigned long *b
   ;
   ; exit  : carry set  if *a < *b
   ;         z flag set if *a == *b
   ;
   ; uses  : af
   
   inc hl
   inc hl
   inc hl                      ; hl = & b.MSB
   
   inc de
   inc de
   inc de                      ; de = & a.MSB

   ld a,(de)
   sub (hl)
   
   dec hl
   dec de
   
   jr nz, exit2

   ld a,(de)
   sub (hl)
   
   dec hl
   dec de
   
   jr nz, exit1
   
   ld a,(de)
   sub (hl)
   
   dec hl
   dec de
   
   ret nz
   
   ld a,(de)
   sub (hl)
   
   ret

exit2:

   dec hl
   dec de

exit1:

   dec hl
   dec de
   
   ret
