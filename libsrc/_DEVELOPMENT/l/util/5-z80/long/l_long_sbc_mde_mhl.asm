
SECTION code_clib
SECTION code_l

PUBLIC l_long_sbc_mde_mhl

l_long_sbc_mde_mhl:

   ; subtract the two longs at addresses hl & de
   ;
   ; enter : de = long *A
   ;         hl = long *B
   ; 
   ; exit  : dehl = A - B - carry
   ;         flags set as result of msb subtraction
   ;
   ; uses  : af, bc, de, hl
   
   ld a,(de)
   inc de
   sbc a,(hl)
   inc hl
   ld c,a
   
   ld a,(de)
   inc de
   sbc a,(hl)
   inc hl
   ld b,a
   
   push bc                     ; save LSW of result
   
   ld a,(de)
   inc de
   sbc a,(hl)
   inc hl
   ld c,a
   
   ld a,(de)
   sbc a,(hl)
   
   ld d,a
   ld e,c
   pop hl                      ; dehl = result
   
   ret
