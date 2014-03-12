
*** THIS FUNCTION IS EXPORTED AS PART OF ASM_B_ARRAY_EMPTY

; ===============================================================
; Mar 2014
; ===============================================================
; 
; int w_array_empty(b_array_t *a)
;
; Return non-zero if the array is empty.
;
; ===============================================================

asm_w_array_empty:

   ; enter : hl = array *
   ;
   ; exit  : if array is empty
   ;
   ;           hl = 1
   ;           z flag set
   ;
   ;         if array is not empty
   ;
   ;           hl = 0
   ;           nz flag set
   ;
   ; uses  : af, hl
