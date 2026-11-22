SECTION code_clib
SECTION code_l_sdcc

PUBLIC ____sdcc_4_or_src_mbc_mhl_dst_deix

____sdcc_4_or_src_mbc_mhl_dst_deix:

IFDEF __SDCC_IX

   push ix

ELSE

   push iy
   
ENDIF

   ex (sp),hl
   
   add hl,de
   ex de,hl
   
   pop hl
   
   ld a,(bc)
   or (hl)
   ld (de),a
   inc bc
   inc de
   inc hl

   ld a,(bc)
   or (hl)
   ld (de),a
   inc bc
   inc de
   inc hl

   ld a,(bc)
   or (hl)
   ld (de),a
   inc bc
   inc de
   inc hl

   ld a,(bc)
   or (hl)
   ld (de),a
   inc hl

   ret
