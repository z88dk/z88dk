; unsigned char esx_dos_catalog(struct esx_cat *cat)

SECTION code_esxdos

PUBLIC _esx_dos_catalog_fastcall

EXTERN asm_esx_dos_catalog

_esx_dos_catalog_fastcall:

   push iy
   
   call asm_esx_dos_catalog
   
   pop iy
   ret
