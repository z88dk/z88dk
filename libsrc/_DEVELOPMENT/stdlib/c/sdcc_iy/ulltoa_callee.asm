
; char *ulltoa(uint64_t num, char *buf, int radix)

SECTION code_clib
SECTION code_stdlib

PUBLIC _ulltoa_callee

EXTERN asm_ulltoa

_ulltoa_callee:

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
   
   call asm_ulltoa
   
   pop ix
   
   ex de,hl
   
   ld hl,12
   add hl,sp
   ld sp,hl
   
   ex de,hl
   
   jp (ix)
