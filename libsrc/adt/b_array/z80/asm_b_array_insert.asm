
; ===============================================================
; Mar 2014
; ===============================================================
; 
; size_t b_array_insert(b_array_t *a, size_t idx, int c)
;
; Insert char c before array.data[idx], returns index of
; char inserted.
;
; ===============================================================

SECTION code_clib
SECTION code_adt_b_array

PUBLIC asm_b_array_insert

EXTERN asm_b_array_insert_block, error_mc

asm_b_array_insert:

   ; enter : hl = array *
   ;         de = int c
   ;         bc = idx
   ;
   ; exit  : success
   ;
   ;            de = & array.data[idx]
   ;            hl = idx of char inserted
   ;            carry reset
   ;
   ;         fail
   ;
   ;            hl = -1
   ;            carry set, errno set
   ;
   ; uses  : af, bc, de, hl

   push bc                     ; save idx
   push de                     ; save int c
   
   ld de,1
   call asm_b_array_insert_block
   
   pop de                      ; de = int c
   jp c, error_mc - 1          ; if insert error

   ld (hl),e                   ; write inserted char
   ex de,hl

   pop hl                      ; hl = idx
   ret
