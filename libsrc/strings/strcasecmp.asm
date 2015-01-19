; CALLER linkage for function pointers

PUBLIC strcasecmp
EXTERN stricmp1

.strcasecmp

   pop bc
   pop de
   pop hl
   push hl
   push de
   push bc
   
   jp stricmp1
