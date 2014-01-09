
; ===============================================================
; Jan 2014
; ===============================================================
; 
; void list_init(void *p)
;
; Create an empty list in the four bytes of memory provided.
;
; ===============================================================

XLIB asm_list_init
XDEF asm_list_clear

LIB asm_forward_list_init, l_setmem_hl

asm_list_init:
asm_list_clear:

   ; enter : hl = void *p
   ;
   ; exit  : hl = void *p + 4
   ;         de = void *p = list *list
   ;
   ; uses  : af, de, hl

   call asm_forward_list_init  ; list->head = 0
   jp l_setmem_hl - 4          ; list->tail = 0
