
*** DO NOT ADD TO LIBRARY
*** THIS FUNCTION IS EXPORTED AS PART OF ASM_P_FORWARD_LIST_REMOVE_AFTER

; ===============================================================
; Dec 2013
; ===============================================================
; 
; void *p_forward_list_pop_front(p_forward_list_t *list)
;
; Pop item from front of list.
;
; ===============================================================

asm_p_forward_list_pop_front:

   ; enter : hl = p_forward_list_t *list
   ;
   ; exit  : hl = void *item (item popped, 0 if none)
   ;         de = p_forward_list_t *list
   ;         carry reset if list was empty
   ;
   ; uses  : af, de, hl
