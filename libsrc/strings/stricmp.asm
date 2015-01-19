; CALLER linkage for function pointers

PUBLIC stricmp
EXTERN stricmp1

.stricmp

   pop bc
   pop de
   pop hl
   push hl
   push de
   push bc
   
   jp stricmp1
