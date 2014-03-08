
; ===============================================================
; Feb 2014
; ===============================================================
; 
; size_t w_vector_append_n(b_vector_t *v, size_t n, void *item)
;
; Append n copies of item to the end of the vector, return
; index of new block.
;
; ===============================================================

XLIB asm_w_vector_append_n

LIB asm_b_vector_append_block, __w_vector_write_n
LIB error_mc, error_enomem_mc

asm_w_vector_append_n:

   ; enter : hl = w_vector_t *
   ;         bc = size_t n
   ;         de = void *item
   ;
   ; exit  : success
   ;
   ;            hl = idx of bytes appended
   ;            de = & vector.array[idx]
   ;            carry reset
   ;
   ;         fail
   ;
   ;            hl = -1
   ;            bc = size_t n * 2
   ;            de = void *item
   ;            carry set, errno set
   ;
   ; uses  : af, bc, de, hl

   sla c
   rl b                        ; num bytes = n * 2
   jp c, error_enomem_mc

   push de                     ; save item
   
   call asm_b_vector_append_block

   ex de,hl
   ex (sp),hl
   ex de,hl
   
   ; bc = n * 2
   ; de = item
   ; hl = & vector.array[idx]
   ; stack = idx

   jp c, error_mc - 1          ; if vector growth failed

   call __w_vector_write_n

   pop de
   ex de,hl
   
   srl h
   rr l                        ; carry flag should never happen
   
   ret
