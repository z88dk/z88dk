SECTION code_clib
SECTION code_l_sdcc

PUBLIC ____sdcc_4_or_src_dehl_dst_bcix

____sdcc_4_or_src_dehl_dst_bcix:

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
   or l
   ld (bc),a
   inc bc
   
   ld a,(bc)
   or h
   ld (bc),a
   inc bc
   
   ld a,(bc)
   or e
   ld (bc),a
   inc bc
   
   ld a,(bc)
   or d
   ld (bc),a

   ret
