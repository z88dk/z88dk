
PUBLIC l_zerostruct6_hl

EXTERN l_setmem_hl

l_zerostruct6_hl:

   ; zero a six-byte struct
   ;
   ; enter : hl = void *struct
   ;
   ; uses  : af, hl
   
   xor a
   jp l_setmem_hl - 12
