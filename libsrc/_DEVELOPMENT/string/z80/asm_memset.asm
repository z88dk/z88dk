
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

IF (__CLIB_OPT_UNROLL & __CLIB_OPT_UNROLL_MEMSET)

   ld a,b
   or a
   
   jr nz, big
   
   or c
   ret z
   
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

   ld a,b
   or c
   
   ret z

   push hl
IF __CPU_GBZ80__ || __CPU_INTEL__
loop:
 IF __CPU_GBZ80__
   ld a,(hl+)
 ELSE
   ld a,(hl)
   inc hl
 ENDIF
   ld (de),a
   inc de
   dec bc
   ld a,b
   or c
   jr nz,loop
ELSE 
   ldir
ENDIF
   
   pop hl
   ret

ENDIF
