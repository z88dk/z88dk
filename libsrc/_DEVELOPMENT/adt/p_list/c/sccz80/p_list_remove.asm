
; void *p_list_remove(p_list_t *list, void *item)

SECTION code_clib
SECTION code_adt_p_list

PUBLIC p_list_remove

EXTERN asm_p_list_remove

p_list_remove:

   pop af
   pop hl
   pop bc
   
   push bc
   push hl
   push af
   
   jp asm_p_list_remove

; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _p_list_remove
defc _p_list_remove = p_list_remove
ENDIF

