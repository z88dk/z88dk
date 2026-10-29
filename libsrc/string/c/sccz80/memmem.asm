
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
   ex (sp),ix
   exx
   pop hl
   exx
   push ix
   push hl
   push de
   push bc
   push af
   exx
   push hl
   exx
   call asm_memmem
   pop ix
   ret
ENDIF

IF __CLASSIC
   push hl
   push de
   push bc
   push af
   exx
   push bc
   exx
   ex (sp),ix
   call asm_memmem
   pop ix
   ret
ENDIF

; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _memmem
defc _memmem = memmem
ENDIF


; Clang bridge for Classic
IF __CLASSIC
PUBLIC ___memmem
defc ___memmem = memmem
ENDIF

ENDIF


