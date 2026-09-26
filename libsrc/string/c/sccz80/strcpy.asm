
; char *strcpy(char * restrict s1, const char * restrict s2)

SECTION code_clib
SECTION code_string

PUBLIC strcpy

EXTERN asm_strcpy

strcpy:

   pop bc
   pop hl
   pop de
   
   push de
   push hl
   push bc
IF __CLASSIC && __CPU_GBZ80__
   call asm_strcpy
   ld d,h
   ld e,l
   ret
ELSE
   jp asm_strcpy
ENDIF

; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _strcpy
defc _strcpy = strcpy
ENDIF


; Clang bridge for Classic (llvmz80 reversed-arg register ABI).
; sys/proto.h declares __strcpy(const char *s2, char *s1) (reversed).
; llvmz80 passes both args in registers: HL=s2 (src), DE=s1 (dst); the
; 16-bit return (dst) goes in DE.  The old `defc ___strcpy = strcpy`
; aliased the sccz80 stack-ABI routine (pops s1,s2) -> wrong -> crash.
IF __CLASSIC
PUBLIC ___strcpy
___strcpy:
   call asm_strcpy          ; enter HL=src, DE=dst; exit HL=dst
   ex de,hl                 ; DE = dst (C return value)
   ret
ENDIF

