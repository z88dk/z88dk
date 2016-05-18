
SECTION code_clib
SECTION code_l_sdcc

PUBLIC ____sdcc_ll_add_deix_bc_hl
PUBLIC ____sdcc_ll_add_deix_bc_hl_0

____sdcc_ll_add_deix_bc_hl:

   push hl
   
   push ix
   pop hl
   
   add hl,de
   ex de,hl
   
   pop hl

____sdcc_ll_add_deix_bc_hl_0:

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
