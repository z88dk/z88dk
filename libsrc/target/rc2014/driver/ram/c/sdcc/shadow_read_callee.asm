
; void *shadow_read_callee(void * restrict s1, const void * restrict s2, size_t n) __z88dk_callee

SECTION smc_lib

PUBLIC _shadow_read_callee

EXTERN asm_push_di
EXTERN asm_pop_ei_jp

EXTERN __IO_RAM_SHADOW_BASE

._shadow_read_callee
   pop af
   pop de
   pop hl
   pop bc
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
