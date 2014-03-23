
; ===============================================================
; Mar 2014
; ===============================================================
; 
; wv_stack_t *wv_stack_init(void *p, size_t capacity, size_t max_size)
;
; Initialize a word vector structure at address p and allocate
; an array of capacity words to begin with.  The vector's array
; will not be allowed to grow beyond max_size words.
;
; Returns p on success or 0 on failure.
;
; ===============================================================

XLIB asm_wv_stack_init

LIB asm_w_vector_init

asm_wv_stack_init:

   jp asm_w_vector_init

;defc asm_wv_stack_init = asm_w_vector_init

   ; enter : de = void *p
   ;         bc = capacity in words
   ;         hl = max_size in words
   ;
   ; exit  : success
   ;
   ;            hl = w_vector_t *
   ;            carry reset
   ;
   ;         fail if required vector > 64k
   ;
   ;            hl = 0
   ;            carry set, errno = ENOMEM
   ;
   ;         fail if max_size < capacity
   ;
   ;            hl = 0
   ;            carry set, errno = EINVAL
   ;
   ;         fail if unsuccessful realloc
   ;
   ;            hl = 0
   ;            carry set, errno set
   ;
   ; uses  : af, bc, de, hl
