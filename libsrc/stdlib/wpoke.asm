; CALLER linkage for function pointers

SECTION code_clib
PUBLIC wpoke
PUBLIC _wpoke
EXTERN asm_wpoke

.wpoke
._wpoke

   pop bc
   pop de
   pop hl
   push hl
   push de
   push bc
   
   jp asm_wpoke

