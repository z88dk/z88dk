
SECTION code_clib
SECTION code_l_sdcc

PUBLIC ____sdcc_store_debc_hlix

____sdcc_store_debc_hlix:

IFDEF __SDCC_IX
   
   push ix
   
ELSE

   push iy

ENDIF

   ex de,hl
   
   ex (sp),hl
   add hl,de
   
   pop de
   
   ld (hl),d
   dec hl
   ld (hl),e
   dec hl
   ld (hl),b
   dec hl
   ld (hl),c
   
   ret
