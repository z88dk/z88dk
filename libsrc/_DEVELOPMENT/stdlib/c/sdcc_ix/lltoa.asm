
; char *lltoa(uint64_t num, char *buf, int radix)

SECTION code_clib
SECTION code_stdlib

PUBLIC _lltoa

EXTERN asm_lltoa

_lltoa:

   ld hl,10
   add hl,sp
   
   ld e,(hl)
   inc hl
   ld d,(hl)                   ; de = buf
   inc hl
   
   ld c,(hl)
   inc hl
   ld b,(hl)                   ; bc = radix
   
   push ix
   
   ld ix,4
   add ix,sp                   ; ix = & num
   
   call asm_lltoa
   
   pop ix
   ret
