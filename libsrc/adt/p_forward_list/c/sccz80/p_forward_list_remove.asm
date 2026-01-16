
; void *p_forward_list_remove(p_forward_list_t *list, void *item)

SECTION code_clib
SECTION code_adt_p_forward_list

PUBLIC p_forward_list_remove

EXTERN asm_p_forward_list_remove

p_forward_list_remove:

   pop af
   pop bc
   pop hl
   
   push hl
   push bc
   push af
   
   jp asm_p_forward_list_remove

; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _p_forward_list_remove
defc _p_forward_list_remove = p_forward_list_remove
ENDIF

