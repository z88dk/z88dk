
; ===============================================================
; Dec 2013 / Dec 2021 feilipu
; ===============================================================
; 
; void *memset(void *s, int c, size_t n)
;
; Write c into the first n bytes of s.
;
; ===============================================================

INCLUDE "config_private.inc"

SECTION code_clib
SECTION code_string

PUBLIC asm_memset

asm_memset:

   ; enter : hl = void *s
   ;          e = char c
   ;         bc = uint n
   ;
   ; exit  : hl = void *s
   ;         de = ptr in s to byte after last one written
   ;         bc = 0
   ;         carry reset
   ;
   ; uses  : af, bc, de

   ld a,b
   or c

   ld a,e
   ld de,hl

   ret Z

IF (__CLIB_OPT_UNROLL & __CLIB_OPT_UNROLL_MEMSET)
   ld (hl),a
   inc de
   dec bc

   ld a,b
   or a

   jr NZ,big

   or c
   ret Z

   push hl

   EXTERN l_ldi_loop_small
   call   l_ldi_loop_small

   pop hl
   ret

big:
   push hl

   EXTERN l_ldi_loop_0
   call   l_ldi_loop_0

   pop hl
   ret

ELSE

IF __CPU_INTEL__ || __CPU_GBZ80__

   push hl

   dec bc
   inc b
   inc c

loop:
   ld (hl+),a

   dec c
   jr NZ,loop
   dec b
   jr NZ,loop

   ex de,hl

ELSE

   ld (hl),a
   inc de
   dec bc

   ld a,b
   or c
   ret Z

   push hl
   ldir

ENDIF

   pop hl
   ret

ENDIF
