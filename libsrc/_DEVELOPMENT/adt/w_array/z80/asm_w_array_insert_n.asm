
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

XLIB asm_w_array_insert_n

LIB error_einval_mc, error_enomem_mc, error_mc
LIB asm_b_array_insert_block, asm_memset

asm_w_array_insert_n:

   ; enter : hl = array *
   ;         de = n
   ;         bc = idx
   ;         af = item
   ;
   ; exit  : success
   ;
   ;            de = & array.data[idx]
   ;            hl = idx of first char inserted
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
   jp c, error_enomem_mc - 2
   
   push de                     ; save n*2
   
   call asm_b_array_insert_block

   pop bc                      ; bc = n*2
   pop de                      ; de = item
   
   jp c, error_mc - 1
   
   call __w_array_write_n      ; fill inserted block
   
   pop de                      ; de = idx
   ex de,hl

   ret
