
SECTION code_clib
SECTION code_l_sdcc

PUBLIC ____sdcc_4_copy_src_mhl_dst_deix
PUBLIC ____sdcc_4_copy_src_mhl_dst_deix_0

____sdcc_4_copy_src_mhl_dst_deix:

IFDEF __SDCC_IX

   push ix

ELSE

   push iy
   
ENDIF

   ex (sp),hl
   
   add hl,de
   ex de,hl
   
   pop hl

____sdcc_4_copy_src_mhl_dst_deix_0:

   ldi
   ldi
   ldi
   ld a,(hl)
   ld (de),a

   inc bc
   inc bc
   inc bc
   
   ret
