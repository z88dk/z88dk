
; void *memchr(const void *s, int c, size_t n)

SECTION code_clib
SECTION code_string

PUBLIC memchr

EXTERN l0_memchr_callee
EXTERN asm_memchr

memchr:
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
   ld l,a
   call l0_memchr_callee
   ld d,h
   ld e,l
   ret
ELSE

   pop af
   pop bc
   pop de
   pop hl
   
   push hl
   push de
   push bc
   push af
   jp l0_memchr_callee
ENDIF


; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _memchr
defc _memchr = memchr
ENDIF


; Clang bridge for Classic (llvmz80 reversed-arg register ABI).
; __memchr(size_t n, int c, const void *s): HL=n, DE=c (E=char),
; s on the stack above the return address, callee-cleaned; ptr in DE.
IF __CLASSIC
PUBLIC ___memchr
___memchr:
   ld c,l
   ld b,h                   ; BC = n
   ld a,e                   ; A = char c
   pop hl                   ; HL = return address
   ex (sp),hl               ; HL = s; [SP] = return address
   call asm_memchr          ; enter A=c, HL=s, BC=n; exit HL=ptr or 0
   ex de,hl                 ; DE = ptr (C return value)
   ret
ENDIF

