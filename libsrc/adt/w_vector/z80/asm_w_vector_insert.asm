
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

SECTION code_clib
SECTION code_adt_w_vector

PUBLIC asm_w_vector_insert

EXTERN asm_b_vector_insert_block, error_mc

asm_w_vector_insert:

   ; enter : hl = vector *
   ;         de = item
   ;         bc = idx
   ;
   ; exit  : success
   ;
   ;            de = & vector.data[idx

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
   jp c, error_mc - 1

   push de                     ; save item
   
   ld de,2
   call asm_b_vector_insert_block
   
   pop de                      ; de = item
   jp c, error_mc - 1          ; if insert error

   ld (hl),e
   inc hl
   ld (hl),d                   ; write inserted word
   dec hl

   ex de,hl

   pop hl                      ; hl = idx
   ret
