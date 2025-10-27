SECTION code_clib
SECTION code_l_sdcc

PUBLIC ____sdcc_4_copy_srcd_hlix_dst_deix

____sdcc_4_copy_srcd_hlix_dst_deix:

IFDEF __SDCC_IX

   push ix

ELSE

   push iy
   
ENDIF

   ex (sp),hl

   add hl,de
   ex de,hl
   
   pop hl

   add hl,de
   
   ldi
   ldi
   ldi
   ld a,(hl)
   ld (de),a
   
   ret
