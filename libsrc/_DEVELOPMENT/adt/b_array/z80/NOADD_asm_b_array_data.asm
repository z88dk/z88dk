
*** THIS FUNCTION IS EXPORTED AS PART OF ASM_B_ARRAY_CAPACITY

; ===============================================================
; Mar 2014
; ===============================================================
; 
; void *b_array_data(b_array_t *a)
;
; Return the address of the array's data, could be 0.
;
; ===============================================================

asm_b_array_data:

   ; enter : hl = array *
   ;
   ; exit  : hl = array.data
   ;
   ; uses  : a, hl
