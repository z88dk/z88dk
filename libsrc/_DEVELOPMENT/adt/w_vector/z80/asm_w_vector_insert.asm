
; ===============================================================
; Feb 2014
; ===============================================================
; 
; size_t w_vector_insert(w_vector_t *v, size_t idx, void *item)
;
; Insert item before vector.array[idx], returns index of
; word inserted.
;
; ===============================================================

XLIB asm_w_vector_insert

LIB asm_b_vector_insert_block, error_einval_mc, error_mc

asm_w_vector_insert:

   ; enter : hl = w_vector_t *
   ;         de = void *item
   ;         bc = size_t idx
   ;
   ; exit  : success
   ;
   ;            de = & vector.array[idx]
   ;            hl = idx of word inserted
   ;            carry reset
   ;
   ;         fail
   ;
   ;            hl = -1
   ;            carry set, errno set
   ;
   ; uses  : af, bc, de, hl

   push bc                     ; save idx
   
   sla c
   rl b
   jp c, error_einval_mc - 1

   push de                     ; save item
   
   ld de,2
   call asm_b_vector_insert_block
   
   pop de                      ; de = item
   jp c, error_mc - 1          ; if error in insert_block

   ld (hl),e
   inc hl
   ld (hl),d                   ; write inserted word
   dec hl

   ex de,hl

   pop hl                      ; hl = idx
   ret
