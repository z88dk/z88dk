; CALLER linkage for function pointers

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
