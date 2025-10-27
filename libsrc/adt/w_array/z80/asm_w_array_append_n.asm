
; ===============================================================
; Mar 2014
; ===============================================================
; 
; size_t w_array_append_n(w_array_t *a, size_t n, void *item)
;
; Append n copies of item to the end of the array, return
; index of first appended item.
;
; ===============================================================

SECTION code_clib
SECTION code_adt_w_array

PUBLIC asm_w_array_append_n
PUBLIC asm1_w_array_append_n

EXTERN asm_b_array_append_block, __w_array_write_n, error_mc

asm_w_array_append_n:

   ; enter : hl = array *
   ;         de = n
   ;         bc = void *item
   ;
   ; exit  : success
   ;
   ;            hl = idx of words appended
   ;            de = & array.data[idx]
   ;            carry reset
   ;
   ;         fail if array too small
   ;
   ;            hl = -1
   ;            carry set
   ;
   ; uses  : af, bc, de, hl

   sla e
   rl d                        ; de = n*2 bytes
   jp c, error_mc

   push bc                     ; save item
   
   call asm_b_array_append_block
   jp c, error_mc - 1

asm1_w_array_append_n:

   ; append successful, now fill appended area
   
   ; bc = n*2
   ; de = idx = old array.size
   ; hl = & array.data[idx]
   ; stack = item

   ex de,hl
   ex (sp),hl
   ex de,hl
   
   ; bc = n*2
   ; de = item
   ; hl = & array.data[idx]
   ; stack = idx
   
   call __w_array_write_n
   
   pop de
   ex de,hl
   
   srl h
   rr l
   
   ret
