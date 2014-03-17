
; ===============================================================
; Jan 2014
; ===============================================================
; 
; void *p_list_back(p_list_t *list)
;
; Return item at back of list without removing it from the list.
;
; ===============================================================

XLIB asm_p_list_back

LIB asm_p_forward_list_front

defc asm_p_list_back = asm_p_forward_list_front - 2

   ; enter : hl = p_list_t *list
   ;
   ; exit  : success
   ;
   ;            hl = void *item (item at back)
   ;            carry reset
   ;
   ;         fail if list is empty
   ;
   ;            hl = 0
   ;            carry set, errno = EINVAL
   ;
   ; uses  : af, hl
