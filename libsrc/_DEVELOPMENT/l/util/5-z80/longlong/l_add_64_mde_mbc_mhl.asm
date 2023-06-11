
SECTION code_clib
SECTION code_l

PUBLIC l_add_64_mde_mbc_mhl

l_add_64_mde_mbc_mhl:

   ; 64-bit addition
   ;
   ; enter : de = int64_t *sum
   ;         bc = int64_t *addend
   ;         hl = int64_t *addend
   ;
   ; exit  : *de = *bc + *hl
   ;
   ;         de += 7
   ;         bc += 7
   ;         hl += 7
   ;
   ; uses  : af, bc, de, hl

   ld a,(bc)
   add a,(hl)
   ld (de),a
   inc bc
   inc de
   inc hl
   
   ld a,(bc)
   adc a,(hl)
   ld (de),a
   
   call again
   
again:

   inc bc
   inc de
   inc hl
   ld a,(bc)
   adc a,(hl)
   ld (de),a

   inc bc
   inc de
   inc hl
   ld a,(bc)
   adc a,(hl)
   ld (de),a

   inc bc
   inc de
   inc hl
   ld a,(bc)
   adc a,(hl)
   ld (de),a

   ret
