; unsigned char esx_dos_catalog_next(struct esx_cat *cat)

SECTION code_esxdos

PUBLIC asm_esx_dos_catalog_next

EXTERN l_asm_esx_dos_catalog

asm_esx_dos_catalog_next:

   ; enter : hl = struct esx_cat *cat (unchanged from last catalog call)
   ;              note that this structure must be in main memory
   ;
   ; exit  : success
   ;
   ;            hl = number of catalog entries filled in (0 if cat is done)
   ;            carry reset
   ;
   ;         fail
   ;
   ;            hl = -1
   ;            carry set, errno set
   ;
   ; uses  : all except af', iy

   xor a
   jp l_asm_esx_dos_catalog
