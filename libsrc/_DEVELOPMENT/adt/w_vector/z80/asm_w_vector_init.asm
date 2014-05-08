
; ===============================================================
; Feb 2014
; ===============================================================
; 
; w_vector_t *w_vector_init(void *p, size_t capacity, size_t max_size)
;
; Initialize a word vector structure at address p and allocate
; space for capacity words to begin with.  The vector's array
; will not be allowed to grow beyond max_size words.
;
; Returns p on success or 0 on failure.
;
; ===============================================================

PUBLIC asm_w_vector_init

EXTERN asm_b_vector_init, error_enomem_zc

asm_w_vector_init:

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
   
   add hl,hl
   jp c, error_enomem_zc
   
   sla c
   rl b
   jp c, error_enomem_zc

   jp asm_b_vector_init
