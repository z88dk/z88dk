; CALLER linkage for function pointers

PUBLIC stricmp
PUBLIC _stricmp
EXTERN stricmp1

.stricmp
._stricmp

   pop bc
   pop de
   pop hl
   push hl
   push de
   push bc
   
   jp stricmp1
