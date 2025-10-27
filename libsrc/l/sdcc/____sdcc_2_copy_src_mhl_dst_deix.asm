
SECTION code_clib
SECTION code_l_sdcc

PUBLIC ____sdcc_2_copy_src_mhl_dst_deix

____sdcc_2_copy_src_mhl_dst_deix:

IFDEF __SDCC_IX

   push ix

ELSE

   push iy
   
ENDIF

   ex (sp),hl
   
   add hl,de
   ex de,hl
   
   pop hl
   
   ldi
   ld a,(hl)
   ld (de),a
   
   inc bc
   ret
