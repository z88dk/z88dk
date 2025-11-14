
; void p_forward_list_init(void *p)

SECTION code_clib
SECTION code_adt_p_forward_list

PUBLIC _p_forward_list_init

EXTERN asm_p_forward_list_init

_p_forward_list_init:

   pop af
   pop hl
   
   push hl
   push af

   jp asm_p_forward_list_init
