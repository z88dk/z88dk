
SECTION code_clib
SECTION code_l_sdcc

PUBLIC ____sdcc_ll_sub_de_bc_hl

____sdcc_ll_sub_de_bc_hl:

   ; de = bc - hl
   
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
