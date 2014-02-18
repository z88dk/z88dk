
*** DO NOT ADD TO LIBRARY
*** THIS FUNCTION IS EXPORTED AS PART OF ASM_P_FORWARD_LIST_EMPTY

; ===============================================================
; Dec 2013
; ===============================================================
; 
; int p_forward_list_alt_empty(p_forward_list_alt_t *list)
;
; Return true (non-zero) if list is empty.
;
; ===============================================================

asm_p_forward_list_alt_empty:

   ; enter : hl = p_forward_list_alt_t *
   ;
   ; exit  : if list is empty
   ;
   ;           hl = 1
   ;           z flag set
   ;
   ;         if list is not empty
   ;
   ;           hl = 0
   ;           nz flag set
   ;
   ; uses  : af, hl
