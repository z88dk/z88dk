; CALLER linkage for function pointers

PUBLIC memopi
PUBLIC _memopi
EXTERN asm_memopi

.memopi
._memopi

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
   
   jp asm_memopi
