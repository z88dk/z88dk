
; ===============================================================
; Jan 2014
; ===============================================================
; 
; void p_list_init(void *p)
;
; Create an empty list in the four bytes of memory provided.
;
; ===============================================================

XLIB asm_p_list_init
XDEF asm_p_list_clear

LIB asm_p_forward_list_init, l_setmem_hl

asm_p_list_init:
asm_p_list_clear:

   ; enter : hl = void *p
   ;
   ; exit  : hl = void *p + 4
   ;         de = void *p = p_list_t *list
   ;
   ; uses  : af, de, hl

   call asm_p_forward_list_init  ; list->head = 0
   jp l_setmem_hl - 4            ; list->tail = 0
