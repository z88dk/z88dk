; unsigned char esx_dos_catalog(struct esx_cat *cat)

SECTION code_esxdos

PUBLIC _esx_dos_catalog

EXTERN _esx_dos_catalog_fastcall

_esx_dos_catalog:

   pop af
   pop hl
   
   push hl
   push af
   
   jp _esx_dos_catalog_fastcall
