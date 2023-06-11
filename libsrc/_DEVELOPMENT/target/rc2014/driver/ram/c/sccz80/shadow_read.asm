
; void *shadow_read(void * restrict s1, const void * restrict s2, size_t n) __smallc

SECTION smc_lib

PUBLIC shadow_read

EXTERN asm_push_di
EXTERN asm_pop_ei_jp

EXTERN __IO_RAM_SHADOW_BASE

.shadow_read
   pop af
   pop bc
   pop hl
   pop de

   push de
   push hl
   push bc
   push af

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
PUBLIC _shadow_read
defc _shadow_read = shadow_read
ENDIF

