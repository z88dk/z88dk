; CALLER linkage for function pointers

SECTION code_clib
PUBLIC strcasecmp
PUBLIC _strcasecmp
EXTERN stricmp1

.strcasecmp
._strcasecmp

   pop bc
   pop de
   pop hl
   push hl
   push de
   push bc
   
   jp stricmp1
