
SECTION code_clib
SECTION code_l_sdcc

PUBLIC ____sdcc_store_dehl_bcix

____sdcc_store_dehl_bcix:

IFDEF __SDCC_IX
   
   push ix
   
ELSE

   push iy

ENDIF

   ex (sp),hl
   add hl,bc
   
   ld (hl),d
   dec hl
   ld (hl),e
   dec hl
   
   pop bc
   
   ld (hl),b
   dec hl
   ld (hl),c
   
   ld l,c
   ld h,b
   
   ret
