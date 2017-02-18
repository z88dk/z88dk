
; ===============================================================
; Dec 2013
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
   ld e,l
   ld d,h

   ret z

   ld (hl),a
   inc de
   dec bc

;;;;;;;;;;;;;;;;;;;;;;;;;;;;
IF __CLIB_OPT_FASTCOPY & $02
;;;;;;;;;;;;;;;;;;;;;;;;;;;;

   ld a,b
   or a
   jr nz, fast_memset
   
   ld a,c

IF __CLIB_OPT_FASTCOPY & $40

   cp 19                       ; self-modifying code break even

ELSE

   cp 25                       ; break even

ENDIF

   jr c, slow_memset

fast_memset:

   push hl

   EXTERN l_fast_memcpy
   call l_fast_memcpy
   
   pop hl
   
   or a
   ret

slow_memset:

   or a

;;;;;;;;;;;;;;;;;;;;;;;;;;;;
ELSE
;;;;;;;;;;;;;;;;;;;;;;;;;;;;

   ld a,b
   or c

;;;;;;;;;;;;;;;;;;;;;;;;;;;;
ENDIF
;;;;;;;;;;;;;;;;;;;;;;;;;;;;

   ret z

   push hl
   
   ldir
   
   pop hl
   ret
