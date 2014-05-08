
; ===============================================================
; Mar 2014
; ===============================================================
; 
; w_array_t *w_array_init(void *p, void *data, size_t capacity)
;
; Initialize a word array structure at address p and set the
; array's initial data and capacity members.  array.size = 0
;
; ===============================================================

PUBLIC asm_w_array_init

EXTERN asm_b_array_init, error_einval_zc

asm_w_array_init:

   ; enter : hl = p
   ;         de = data
   ;         bc = capacity in words
   ;
   ; exit  : success
   ;
   ;            hl = array *
   ;            carry reset
   ;
   ;         fail if capacity too large
   ;
   ;            hl = 0
   ;            carry set, errno = EINVAL
   ;
   ; uses  : af, bc
   
   sla c
   rl b
   jp nc, asm_b_array_init
   
   jp error_einval_zc
