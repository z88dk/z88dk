
; void *memmem(const void *big, size_t big_len, const void *little, size_t little_len)
IF !__CPU_INTEL__ & !__CPU_GBZ80__
SECTION code_clib
SECTION code_string

PUBLIC memmem

EXTERN asm_memmem
EXTERN asm_memmem

memmem:

   pop af
   pop bc
   pop de
   pop hl
IF __CLASSIC
   exx
   pop bc
   push bc
   exx
ELSE
   pop ix
   
   push ix
ENDIF
   push hl
   push de
   push bc
   push af
   
IF __CLASSIC
   exx
   push bc
   exx
   ex  (sp),ix
   call asm_memmem
   pop ix
   ret
ELSE
   jp asm_memmem
ENDIF

; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _memmem
defc _memmem = memmem
ENDIF

ENDIF
