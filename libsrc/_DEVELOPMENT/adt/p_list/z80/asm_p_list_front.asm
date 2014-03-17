
; ===============================================================
; Dec 2013
; ===============================================================
; 
; void *p_list_front(p_list_t *list)
;
; Return item at front of list without removing it from the list.
;
; ===============================================================

XLIB asm_p_list_front

LIB asm_p_forward_list_front

defc asm_p_list_front = asm_p_forward_list_front

   ; enter : hl = p_list_t *list
   ;
   ; exit  : success
   ;
   ;            hl = void *item (item at front)
   ;            carry reset
   ;
   ;         fail if list is empty
   ;
   ;            hl = 0
   ;            carry set, errno = EINVAL
   ;
   ; uses  : af, hl
