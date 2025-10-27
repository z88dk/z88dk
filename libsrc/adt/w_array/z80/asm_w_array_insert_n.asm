
; ===============================================================
; Mar 2014
; ===============================================================
; 
; size_t w_array_insert_n(w_array_t *a, size_t idx, size_t n, void *item)
;
; Insert n words before array.data[idx], fill that area with
; item and return the index of the first word inserted.
;
; ===============================================================

SECTION code_clib
SECTION code_adt_w_array

PUBLIC asm_w_array_insert_n
PUBLIC asm1_w_array_insert_n

EXTERN error_mc
EXTERN asm_b_array_insert_block, __w_array_write_n

asm_w_array_insert_n:

   ; enter : hl = array *
   ;         de = n
   ;         bc = idx
   ;         af = item
   ;
   ; exit  : success
   ;
   ;            de = & array.data[idx]
   ;            hl = idx of first word inserted
   ;            carry reset
   ;
   ;         fail
   ;
   ;            hl = -1
   ;            carry set
   ;
   ; uses  : af, bc, de, hl

   push bc                     ; save idx
   push af                     ; save item
   
   sla c
   rl b
   jp c, error_mc - 2
   
   sla e
   rl d
   jp c, error_mc - 2
   
   push de                     ; save n*2
   
   call asm_b_array_insert_block

asm1_w_array_insert_n:

   pop bc                      ; bc = n*2
   pop de                      ; de = item
   
   jp c, error_mc - 1
   
   call __w_array_write_n      ; fill inserted block
   
   pop de                      ; de = idx
   ex de,hl

   ret
