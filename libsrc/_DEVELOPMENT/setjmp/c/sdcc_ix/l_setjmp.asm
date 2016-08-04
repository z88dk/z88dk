
; djm 28/2/2000

; int l_setjmp(jmp_buf *env)

SECTION code_clib
SECTION code_setjmp

PUBLIC _l_setjmp

EXTERN error_znc

_l_setjmp:

   pop bc
   pop hl
   
   push hl
   push bc
   
   ; hl = jmp_buf *env
   ; bc = return address

   push ix
   pop de
   
   ld (hl),e
   inc hl
   ld (hl),d
   inc hl
   
   push iy
   pop de
   
   ld (hl),e
   inc hl
   ld (hl),d
   inc hl
   
   ex de,hl
   
   ld hl,2
   add hl,sp
   
   ex de,hl
   
   ld (hl),e
   inc hl
   ld (hl),d
   inc hl

   ld (hl),c
   inc hl
   ld (hl),b
   
   jp error_znc
