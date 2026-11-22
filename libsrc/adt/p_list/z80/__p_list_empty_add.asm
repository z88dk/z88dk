SECTION code_clib
SECTION code_adt_p_list

PUBLIC __p_list_empty_add

EXTERN l_setmem_hl

__p_list_empty_add:

   ; bc = p_list_t *list
   ; de = void *item

   ld l,c
   ld h,b
   
   ld (hl),e
   inc hl
   ld (hl),d
   inc hl
   ld (hl),e
   inc hl
   ld (hl),d
   
   ld l,e
   ld h,d
   
   xor a
   call l_setmem_hl - 8
   
   ex de,hl
   ret
