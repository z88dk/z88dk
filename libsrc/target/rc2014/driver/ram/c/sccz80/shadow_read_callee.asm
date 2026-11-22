
; void *shadow_read(void * restrict s1, const void * restrict s2, size_t n) __smallc __z88dk_callee

SECTION smc_lib

PUBLIC shadow_read_callee

EXTERN asm_push_di
EXTERN asm_pop_ei_jp

EXTERN __IO_RAM_SHADOW_BASE

.shadow_read_callee
   pop hl
   pop bc
   pop de
   ex (sp),hl
   ex de,hl

   ld a,b
   or c
   ret Z

   call asm_push_di

   push hl
   ld hl,asm_pop_ei_jp
   ex (sp),hl

   push hl
   ld hl,(__IO_RAM_SHADOW_BASE)
   ex (sp),hl

   scf          ; set up read from shadow ram
   ret          ; jp (__IO_RAM_SHADOW_BASE)

; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _shadow_read_callee
defc _shadow_read_callee = shadow_read_callee
ENDIF

