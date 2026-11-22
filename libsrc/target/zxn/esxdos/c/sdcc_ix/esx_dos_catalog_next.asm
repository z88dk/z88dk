; unsigned char esx_dos_catalog_next(struct esx_cat *cat)

SECTION code_esxdos

PUBLIC _esx_dos_catalog_next

EXTERN _esx_dos_catalog_next_fastcall

_esx_dos_catalog_next:

   pop af
   pop hl
   
   push hl
   push af
   
   jp _esx_dos_catalog_next_fastcall
