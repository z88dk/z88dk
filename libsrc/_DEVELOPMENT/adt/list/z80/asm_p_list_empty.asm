
*** DO NOT ADD TO LIBRARY
*** THIS FUNCTION IS EXPORTED AS PART OF ASM_P_FORWARD_LIST_EMPTY

; ===============================================================
; Jan 2014
; ===============================================================
; 
; int p_list_empty(p_list_t *list)
;
; Return true (non-zero) if list is empty.
;
; ===============================================================

asm_p_list_empty:

   ; enter : hl = p_list_t *
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
