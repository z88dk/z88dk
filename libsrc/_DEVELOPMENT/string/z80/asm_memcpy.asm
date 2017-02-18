
; ===============================================================
; Dec 2013
; ===============================================================
; 
; void *memcpy(void * restrict s1, const void * restrict s2, size_t n)
;
; Copy n chars from s2 to s1, return s1.
;
; ===============================================================

INCLUDE "config_private.inc"

SECTION code_clib
SECTION code_string

PUBLIC asm_memcpy
PUBLIC asm0_memcpy, asm1_memcpy

asm_memcpy:

   ; enter : bc = size_t n
   ;         hl = void *s2 = src
   ;         de = void *s1 = dst
   ;
   ; exit  : hl = void *s1 = dst
   ;         de = ptr in s1 to one byte past last byte copied
   ;         bc = 0
   ;         carry reset
   ;
   ; uses  : af, bc, de, hl

   ld a,b
   or c
   jr z, zero_n

asm0_memcpy:

   push de

;;;;;;;;;;;;;;;;;;;;;;;;;;;;
IF __CLIB_OPT_FASTCOPY & $01
;;;;;;;;;;;;;;;;;;;;;;;;;;;;

   ld a,b
   or a
   jr nz, fast_memcpy
   
   ld a,c

IF __CLIB_OPT_FASTCOPY & $40

   cp 19                       ; self-modifying code break even

ELSE

   cp 25                       ; break even

ENDIF

   jr c, slow_memcpy

fast_memcpy:

   EXTERN l_fast_memcpy
   call l_fast_memcpy
   
   pop hl
   
   or a
   ret

slow_memcpy:

;;;;;;;;;;;;;;;;;;;;;;;;;;;;
ENDIF
;;;;;;;;;;;;;;;;;;;;;;;;;;;;
   
   ldir
   
   pop hl
   
   or a
   ret

asm1_memcpy:
zero_n:

   ld l,e
   ld h,d
   
   ret
