
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

XLIB asm_p_forward_list_init
XDEF asm_p_forward_list_clear
XDEF asm_p_stack_init, asm_p_stack_clear

LIB l_setmem_hl

asm_p_forward_list_init:
asm_p_forward_list_clear:
asm_p_stack_init:
asm_p_stack_clear:

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
