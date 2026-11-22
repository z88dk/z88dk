
; char *ulltoa(uint64_t num, char *buf, int radix)

SECTION code_clib
SECTION code_stdlib

PUBLIC ulltoa

EXTERN asm_ulltoa

ulltoa:

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
   
   push bc
   push bc
   push de
   push hl
   push de
   push hl
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
PUBLIC _ulltoa
defc _ulltoa = ulltoa
ENDIF
