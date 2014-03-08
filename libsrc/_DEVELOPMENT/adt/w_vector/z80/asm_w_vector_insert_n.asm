
; ===============================================================
; Feb 2014
; ===============================================================
; 
; size_t w_vector_insert_n(w_vector_t *v, size_t idx, size_t n, void *item)
;
; Insert n words before vector.array[idx], fill that area with
; item and return the index of the first word inserted.
;
; ===============================================================

XLIB asm_w_vector_insert_n

LIB asm_b_vector_insert_block, __w_vector_write_n, error_mc

asm_w_vector_insert_n:

   ; enter : hl = w_vector_t *
   ;         de = size_t n
   ;         bc = size_t idx
   ;         af = void *item
   ;
   ; exit  : success
   ;
   ;            de = & vector.array[idx]
   ;            hl = idx of first word inserted
   ;            carry reset
   ;
   ;         fail
   ;
   ;            hl = -1
   ;            carry set, errno set
   ;
   ; uses  : af, bc, de, hl

   push bc                     ; save idx
   push af                     ; save item
   
   sla c
   rl b 
   jp c, error_einval_mc - 2
   
   sla e
   rl d
   jp c, error_einval_mc - 2
   
   push de                     ; save n*2
   
   call asm_b_vector_insert_block

   pop bc                      ; bc = n*2
   pop de                      ; de = item
   
   jp c, error_mc - 1

   call __w_vector_write_n

   pop de                      ; de = idx
   ex de,hl

   ret
