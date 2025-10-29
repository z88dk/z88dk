
; ===============================================================
; Dec 2013
; ===============================================================
; 
; void p_forward_list_init(void *p)
;
; Create an empty forward_list in the two bytes of memory
; provided.
;
; ===============================================================

SECTION code_clib
SECTION code_adt_p_forward_list

PUBLIC asm_p_forward_list_init

EXTERN l_setmem_hl

asm_p_forward_list_init:

   ; enter : hl = void *p
   ;
   ; exit  : hl = void *p + 2
   ;         de = void *p = p_forward_list_t *list
   ;
   ; uses  : af, de, hl

   ld e,l
   ld d,h
   
   xor a
   jp l_setmem_hl - 4          ; p_forward_list->next = 0
