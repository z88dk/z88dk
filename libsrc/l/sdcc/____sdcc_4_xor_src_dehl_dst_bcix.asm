SECTION code_clib
SECTION code_l_sdcc

PUBLIC ____sdcc_4_xor_src_dehl_dst_bcix

____sdcc_4_xor_src_dehl_dst_bcix:

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
   xor l
   ld (bc),a
   inc bc
   
   ld a,(bc)
   xor h
   ld (bc),a
   inc bc
   
   ld a,(bc)
   xor e
   ld (bc),a
   inc bc
   
   ld a,(bc)
   xor d
   ld (bc),a

   ret
