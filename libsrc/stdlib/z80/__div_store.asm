
SECTION code_clib
SECTION code_stdlib

PUBLIC __div_store

__div_store:

   ex (sp),hl                  ; hl = div_t *
   
   ld (hl),e
   inc hl
   ld (hl),d
   inc hl
   
   pop bc                      ; bc = hl/de
   
   ld (hl),c
   inc hl
   ld (hl),b
   
   ld l,c
   ld h,b
   ret
