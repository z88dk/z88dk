
; void *shadowwrite(void * restrict s1, const void * restrict s2, size_t n)

SECTION smc_lib

PUBLIC shadowwrite

EXTERN asm_push_di
EXTERN asm_pop_ei_jp

EXTERN asm_shadowcopy

.shadowwrite
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

   call asm_push_di

   ld a,b
   or c

   ld a,$00     ; set up write to shadow ram

IF __CLASSIC && __CPU_GBZ80__
   call NZ,asm_shadowcopy
   ld d,h
   ld e,l
   jp asm_pop_ei_jp
ELSE 
   call NZ,asm_shadowcopy
   jp asm_pop_ei_jp
ENDIF

; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _shadowwrite
defc _shadowwrite = shadowwrite
ENDIF

