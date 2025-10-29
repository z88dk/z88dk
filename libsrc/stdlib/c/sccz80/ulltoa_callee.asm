
; char *ulltoa(uint64_t num, char *buf, int radix)

SECTION code_clib
SECTION code_stdlib

PUBLIC ulltoa_callee

EXTERN asm_ulltoa

ulltoa_callee:

   pop af	;ret
   pop bc	;radix
   exx
   pop bc	;buf
   exx
   pop hl	;num
   pop de	;num
   exx
   pop hl	;num
   pop de	;num
   exx

   push af
   
   exx
   push bc
   exx
   ex (sp),ix
   
   call asm_ulltoa
   
   pop ix
   ret


; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _ulltoa_callee
defc _ulltoa_callee = ulltoa_callee
ENDIF
