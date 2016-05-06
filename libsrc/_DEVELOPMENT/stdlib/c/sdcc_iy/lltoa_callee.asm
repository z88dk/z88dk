
; char *lltoa(uint64_t num, char *buf, int radix)

SECTION code_clib
SECTION code_stdlib

PUBLIC _lltoa_callee

EXTERN asm_lltoa

_lltoa_callee:

   ld hl,10
   add hl,sp
   
   ld e,(hl)
   inc hl
   ld d,(hl)                   ; de = buf
   inc hl
   
   ld c,(hl)
   inc hl
   ld b,(hl)                   ; bc = radix
   
   ld ix,2
   add ix,sp                   ; ix = & num
   
   call asm_lltoa
   
   pop ix
   
   ex de,hl
   
   ld hl,12
   add hl,sp
   ld sp,hl
   
   ex de,hl
   
   jp (ix)
