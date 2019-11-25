
; BSD
; void bcopy(const void *src, void *dst, size_t len)

SECTION code_clib
SECTION code_string

PUBLIC bcopy_callee

EXTERN asm_bcopy

bcopy_callee:
IF __CPU_GBZ80__
   pop af	;ret
   pop bc	;len
   pop de	;dst
   pop hl	;src
   push af
ELSE
   pop hl
   pop bc
   pop de
   ex (sp),hl
ENDIF
   
   jp asm_bcopy

; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _bcopy_callee
defc _bcopy_callee = bcopy_callee
ENDIF

