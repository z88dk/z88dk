
*** DO NOT ADD TO LIBRARY
*** THIS FUNCTION IS EXPORTED AS PART OF ASM_P_FORWARD_LIST_FRONT

; ===============================================================
; Dec 2013
; ===============================================================
; 
; void *p_forward_list_alt_front(p_forward_list_alt_t *list)
;
; Return item at front of list without removing it from the list.
;
; ===============================================================

asm_p_forward_list_alt_front:

   ; enter : hl = p_forward_list_alt_t *list
   ;
   ; exit  : hl = void *item (item at front, 0 if none)
   ;         z flag set if list was empty
   ;
   ; uses  : af, hl
