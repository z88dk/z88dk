
; ===============================================================
; Mar 2014
; ===============================================================
; 
; b_array_t *b_array_init(void *p, void *data, size_t capacity)
;
; Initialize a byte array structure at address p and set the
; array's initial data and capacity members.  array.size = 0
;
; ===============================================================

SECTION code_clib
SECTION code_adt_b_array

PUBLIC asm_b_array_init

EXTERN l_setmem_hl

asm_b_array_init:

   ; enter : hl = p
   ;         de = data
   ;         bc = capacity
   ;
   ; exit  : hl = array * = p
   ;
   ; uses  : af
   
   push hl
   
   ld (hl),e
   inc hl
   ld (hl),d                   ; array.data = data
   inc hl
   
   xor a
   call l_setmem_hl - 4        ; array.size = 0
   
   ld (hl),c
   inc hl
   ld (hl),b                   ; array.capacity = capacity
   
   pop hl
   ret
