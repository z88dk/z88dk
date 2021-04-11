; CALLER linkage for function pointers

SECTION code_clib
PUBLIC wpoke
PUBLIC _wpoke
EXTERN asm_wpoke

.wpoke
._wpoke

   pop af
   pop de
   pop hl
   push hl
   push de
   push af
   
   jp asm_wpoke

