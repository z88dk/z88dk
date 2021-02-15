
; void *shadowwrite(void * restrict s1, const void * restrict s2, size_t n)

SECTION code_driver

PUBLIC shadowwrite

EXTERN asm_cpu_push_di
EXTERN asm_cpu_pop_ei

EXTERN asm_shadowcopy

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

   call asm_cpu_push_di

   xor a    ; set up write to shadow ram

IF __CLASSIC && __CPU_GBZ80__
   call asm_shadowcopy
   ld d,h
   ld e,l
   jp asm_cpu_pop_ei
ELSE 
   call asm_shadowcopy
   jp asm_cpu_pop_ei
ENDIF

; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _shadowwrite
defc _shadowwrite = shadowwrite
ENDIF

