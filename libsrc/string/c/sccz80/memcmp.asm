
; int memcmp(const void *s1, const void *s2, size_t n)

SECTION code_clib
SECTION code_string

PUBLIC memcmp

EXTERN asm_memcmp

memcmp:
IF __CPU_GBZ80__ | __CPU_INTEL__
   ld hl,sp+2
   ld c,(hl)
   inc hl
   ld b,(hl)
   inc hl
   ld e,(hl)
   inc hl
   ld d,(hl)
   inc hl
   ld a,(hl+)
   ld h,(hl)
   ld l,e
   ld e,a
   ld a,d
   ld d,h
   ld h,a
ELSE

   pop af
   pop bc
   pop hl
   pop de
   
   push de
   push hl
   push bc
   push af
ENDIF
  
IF __CLASSIC && __CPU_GBZ80__
   call asm_memcmp
   ld d,h
   ld e,l
   ret
ELSE 
   jp asm_memcmp
ENDIF

; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _memcmp
defc _memcmp = memcmp
ENDIF


; Clang bridge for Classic (llvmz80 reversed-arg register ABI).
; __memcmp(size_t n, const void *s2, const void *s1): HL=n, DE=s2,
; s1 on the stack above the return address, callee-cleaned; int in DE.
IF __CLASSIC
PUBLIC ___memcmp
___memcmp:
   ld c,l
   ld b,h                   ; BC = n
   pop hl                   ; HL = return address
   ex (sp),hl               ; HL = s1; [SP] = return address
   ex de,hl                 ; DE = s1, HL = s2
   call asm_memcmp          ; enter BC=n, HL=s2, DE=s1; exit HL=signed result
   ex de,hl                 ; DE = result (C return value)
   ret
ENDIF

