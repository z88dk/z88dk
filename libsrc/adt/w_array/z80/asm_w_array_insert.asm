
; ===============================================================
; Mar 2014
; ===============================================================
; 
; size_t w_array_insert(w_array_t *a, size_t idx, void *item)
;
; Insert item before array.data[idx], returns index of
; word inserted.
;
; ===============================================================

SECTION code_clib
SECTION code_adt_w_array

PUBLIC asm_w_array_insert

EXTERN asm_b_array_insert_block, error_mc

asm_w_array_insert:

   ; enter : hl = array *
   ;         de = item
   ;         bc = idx
   ;
   ; exit  : success
   ;
   ;            de = & array.data[idx]
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
   call asm_b_array_insert_block
   
   pop de                      ; de = item
   jp c, error_mc - 1

   ld (hl),e                   ; write inserted item
   inc hl
   ld (hl),d
   dec hl
   
   ex de,hl

   pop hl                      ; hl = idx
   ret
