SECTION code_clib
SECTION code_l_sdcc

PUBLIC ____sdcc_4_or_src_debc_hlix_dst_debc

____sdcc_4_or_src_debc_hlix_dst_debc:

IFDEF __SDCC_IX

   push ix

ELSE

   push iy
   
ENDIF

   ex de,hl
   ex (sp),hl
   
   add hl,de
   
   pop de
   
   ld a,(hl)
   or c
   ld c,a
   inc hl
   ld a,(hl)
   or b
   ld b,a
   inc hl
   ld a,(hl)
   or e
   ld e,a
   inc hl
   ld a,(hl)
   or d
   ld d,a
   
   ret
