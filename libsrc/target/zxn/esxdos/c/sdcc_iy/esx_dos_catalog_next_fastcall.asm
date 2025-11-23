; unsigned char esx_dos_catalog_next(struct esx_cat *cat)

SECTION code_esxdos

PUBLIC _esx_dos_catalog_next_fastcall

EXTERN asm_esx_dos_catalog_next

_esx_dos_catalog_next_fastcall:

   push iy
   
   call asm_esx_dos_catalog_next
   
   pop iy
   ret
