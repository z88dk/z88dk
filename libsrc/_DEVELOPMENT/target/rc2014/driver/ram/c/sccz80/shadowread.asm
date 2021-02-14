
; void *shadowread(void * restrict s1, const void * restrict s2, size_t n)

SECTION code_driver

PUBLIC shadowread

EXTERN asm_shadowread

shadowread:
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

   ld a,1   ; set up read from shadow ram

IF __CLASSIC && __CPU_GBZ80__
   call asm_shadowread
   ld d,h
   ld e,l
   ret
ELSE 
   jp asm_shadowread
ENDIF

; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _shadowread
defc _shadowread = shadowread
ENDIF

