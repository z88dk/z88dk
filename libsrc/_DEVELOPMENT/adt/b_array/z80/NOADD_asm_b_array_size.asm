
*** THIS FUNCTION IS EXPORTED AS PART OF ASM_B_ARRAY_CAPACITY

; ===============================================================
; Mar 2014
; ===============================================================
; 
; size_t b_array_size(b_array_t *a)
;
; Return the array's current size.
;
; ===============================================================

asm_b_array_size:

   ; enter : hl = array *
   ;
   ; exit  : hl = size
   ;
   ; uses  : a, hl
