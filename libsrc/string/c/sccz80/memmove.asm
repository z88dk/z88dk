
; void *memmove(void *s1, const void *s2, size_t n)

SECTION code_clib
SECTION code_string

PUBLIC memmove

EXTERN asm_memmove

memmove:
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
   call asm_memmove
   ld d,h
   ld e,l
   ret
ELSE 
   jp asm_memmove
ENDIF

; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _memmove
defc _memmove = memmove
ENDIF


; Clang bridge for Classic (llvmz80 / ez80-clang reversed-arg ABI).
;
; sys/proto.h declares, under the clang path, reversed positional args:
;   void *__memmove(size_t n, const void *s2, void *s1)
; so memmove(dst,src,n) lowers to __memmove(n,src,dst): HL = n,
; DE = src (s2), dst (s1) on the stack above the return address, callee
; cleans the stack arg, 16-bit return in DE.  Same shape as __memcpy.
;
; The old `defc ___memmove = memmove` aliased to the sccz80 memmove
; (pops s1,s2,n off the stack) — wrong ABI -> garbage -> crash.
IF __CLASSIC
PUBLIC ___memmove
___memmove:
   ld c,l
   ld b,h                   ; BC = n (count)
   pop hl                   ; HL = return address
   ex (sp),hl               ; HL = s1 (dst); [SP] = return address
   ex de,hl                 ; DE = dst, HL = src (s2)
   call asm_memmove         ; enter BC=n, HL=src, DE=dst; exit HL=dst
   ex de,hl                 ; DE = dst (C return value)
   ret
ENDIF

