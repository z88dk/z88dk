SECTION code_clib
SECTION code_l_sdcc

PUBLIC ____sdcc_4_and_src_dehl_dst_bcix

____sdcc_4_and_src_dehl_dst_bcix:

IFDEF __SDCC_IX

   push ix

ELSE

   push iy
   
ENDIF

   ex (sp),hl
   
   add hl,bc
   ld c,l
   ld b,h
   
   pop hl
   
   ld a,(bc)
   and l
   ld (bc),a
   inc bc
   
   ld a,(bc)
   and h
   ld (bc),a
   inc bc
   
   ld a,(bc)
   and e
   ld (bc),a
   inc bc
   
   ld a,(bc)
   and d
   ld (bc),a

   ret
