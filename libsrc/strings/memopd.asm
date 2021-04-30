; CALLER linkage for function pointers

PUBLIC memopd
PUBLIC _memopd
EXTERN asm_memopd

.memopd
._memopd

   pop af
   pop ix
   pop bc
   pop de
   pop hl
   push hl
   push de
   push bc
   push bc
   push af
   
   jp asm_memopd
