
; void *memset(void *s, int c, size_t n)

SECTION code_clib
SECTION code_string

PUBLIC memset

EXTERN asm_memset

memset:
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
ELSE

   pop af
   pop bc
   pop de
   pop hl
   
   push hl
   push de
   push bc
   push af
ENDIF
  
IF __CLASSIC && __CPU_GBZ80__
   call asm_memset
   ld d,h
   ld e,l
   ret
ELSE 
   jp asm_memset
ENDIF

; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _memset
defc _memset = memset
ENDIF


; Clang bridge for Classic (llvmz80 / ez80-clang reversed-arg ABI).
;
; sys/proto.h declares, under the clang path, the helper with REVERSED
; positional args:  void *__memset(size_t n, int c, void *s)
; so the source call memset(s,'X',7) lowers to __memset(7,'X',s) with
; the z80-clang convention: 1st 16-bit arg in HL, 2nd in DE, remaining
; on the stack, and the CALLEE cleans the stack args.  Concretely at
; entry:  HL = n (count), E = c (fill char), and s (dst) sits on the
; stack just above the return address.  The 16-bit return value (dst)
; goes in DE (llvmz80 returns 16-bit in DE, e.g. `ex de,hl` / `ld de,42`).
;
; The old `defc ___memset = memset` aliased this to the sccz80 memset,
; which pops THREE stack words (s,c,n) — a completely different ABI —
; so it read garbage and ran LDIR with a garbage count (crash/hang).
;
; Worked example: memset(buf, 'X', 7):
;   entry  HL=0x0007  E=0x58  stack=[ret, &buf]
;   ->     BC=7, HL=&buf, E='X'  -> asm_memset  -> HL=&buf, DE=&buf+7
;   ->     DE=&buf (return), stack=[ret]
IF __CLASSIC
PUBLIC ___memset
___memset:
   ld c,l
   ld b,h                   ; BC = n (count)
   pop hl                   ; HL = return address
   ex (sp),hl               ; HL = s (dst); [SP] = return address
   call asm_memset          ; enter HL=s, E=c, BC=n; exit HL=s, DE=s+n
   ex de,hl                 ; DE = s (C return value = dst)
   ret
ENDIF

