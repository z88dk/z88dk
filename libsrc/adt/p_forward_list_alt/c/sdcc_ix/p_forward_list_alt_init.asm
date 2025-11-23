
; void p_forward_list_alt_init(void *p)

SECTION code_clib
SECTION code_adt_p_forward_list_alt

PUBLIC _p_forward_list_alt_init

EXTERN asm_p_forward_list_alt_init

_p_forward_list_alt_init:

   pop af
   pop hl
   
   push hl
   push af

   jp asm_p_forward_list_alt_init
