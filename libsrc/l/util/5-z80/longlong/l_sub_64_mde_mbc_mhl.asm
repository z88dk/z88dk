
SECTION code_clib
SECTION code_l

PUBLIC l_sub_64_mde_mbc_mhl

l_sub_64_mde_mbc_mhl:

   ; 64-bit subtraction
   ;
   ; enter : de = int64_t *difference
   ;         bc = int64_t *minuend
   ;         hl = int64_t *subtrahend
   ;
   ; exit  : *de = *bc - *hl
   ;
   ;         de += 7
   ;         bc += 7
   ;         hl += 7
   ;
   ; uses  : af, bc, de, hl

   ld a,(bc)
   sub a,(hl)
   ld (de),a
   inc bc
   inc de
   inc hl
   
   ld a,(bc)
   sbc a,(hl)
   ld (de),a
   
   call again
   
again:

   inc bc
   inc de
   inc hl
   ld a,(bc)
   sbc a,(hl)
   ld (de),a

   inc bc
   inc de
   inc hl
   ld a,(bc)
   sbc a,(hl)
   ld (de),a

   inc bc
   inc de
   inc hl
   ld a,(bc)
   sbc a,(hl)
   ld (de),a

   ret
