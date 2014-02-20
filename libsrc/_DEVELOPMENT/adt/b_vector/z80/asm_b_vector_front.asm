
; ===============================================================
; Feb 2014
; ===============================================================
; 
; int b_vector_front(b_vector_t *v)
;
; Return char stored at front of vector.
; No check if vector is empty.
;
; ===============================================================

XLIB asm_b_vector_front

asm_b_vector_front:

   ; enter : hl = b_vector_t *
   ;
   ; exit  : hl = char at front of vector
   ;
   ; uses  : a, hl
   
   ld a,(hl)
   inc hl
   ld h,(hl)
   ld l,a                      ; hl = vector.array
   
   ld l,(hl)
   ld h,0
   
   ret
