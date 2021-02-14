
; void *shadowwrite(void * restrict s1, const void * restrict s2, size_t n)

SECTION code_driver

PUBLIC shadowwrite

EXTERN asm_shadowwrite

shadowwrite:
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

   xor a    ; set up write to shadow ram

IF __CLASSIC && __CPU_GBZ80__
   call asm_shadowwrite
   ld d,h
   ld e,l
   ret
ELSE 
   jp asm_shadowwrite
ENDIF

; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _shadowwrite
defc _shadowwrite = shadowwrite
ENDIF

