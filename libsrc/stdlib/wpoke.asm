; CALLER linkage for function pointers

SECTION code_clib
PUBLIC wpoke
PUBLIC _wpoke
PUBLIC ___wpoke
EXTERN asm_wpoke

.wpoke
._wpoke
.___wpoke

   pop bc
   pop de
   pop hl
   push hl
   push de
   push bc
   
   jp asm_wpoke

