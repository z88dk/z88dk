
; ===============================================================
; Feb 2014
; ===============================================================
; 
; int b_vector_reserve(b_vector_t *v, size_t n)
;
; Allocate at least n bytes for the vector's array.
;
; If the array is already larger, do nothing.
;
; ===============================================================

XLIB asm_b_vector_reserve

LIB __vector_reserve, error_znc, error_mc

asm_b_vector_reserve:

   ; enter : hl = b_vector_t *
   ;         bc = size_t n
   ;
   ; exit  : bc = size_t n
   ;         de = & vector.capacity + 1b
   ;
   ;         success
   ;
   ;            hl = 0
   ;            carry reset
   ;
   ;         fail
   ;
   ;            hl = -1
   ;            carry set, errno set
   ;
   ; uses  : af, de, hl

   inc hl
   inc hl
   inc hl                      ; hl = & vector.size + 1b
   
   call __vector_reserve

   jp nc, error_znc            ; if successful
   jp error_mc                 ; if fail
