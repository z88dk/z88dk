
; djm 28/2/2000

; int l_setjmp(jmp_buf *env)

SECTION code_clib
SECTION code_setjmp

PUBLIC l_setjmp

EXTERN error_znc

l_setjmp:

   pop bc
   pop de
   
   push de
   push bc
   
   ld hl,2
   add hl,sp
   
   ex de,hl
   
   ; hl = jmp_buf *env
   ; de = sp at return address
   ; bc = return address
   
   ld (hl),e
   inc hl
   ld (hl),d
   inc hl
   
   ld (hl),c
   inc hl
   ld (hl),b
   
   jp error_znc
