
; ===============================================================
; Dec 2013
; ===============================================================
; 
; void *memswap(void *s1, void *s2, size_t n)
;
; Swap n bytes pointed at by s1 and s2.
;
; ===============================================================

SECTION code_clib
SECTION code_string

PUBLIC asm_memswap
PUBLIC asm0_memswap

asm_memswap:

   ; enter : bc = size_t n
   ;         de = void *s2
   ;         hl = void *s1
   ;
   ; exit  : hl = void *s1
   ;         de = ptr in s2 to byte after last one written
   ;         bc = 0
   ;         carry reset
   ;
   ; uses  : af, bc, de

   ld a,b
   or c
   ret z

asm0_memswap:

   push hl

loop:
   
   ld a,(de)
IF __CPU_GBZ80__ || __CPU_INTEL__
   push bc
   ld c,a
   ld a,(hl)
   ld (de),a
   inc de
   ld a,c
 IF __CPU_GBZ80__
   ld (hl+),a
 ELSE
   ld (hl),a
   inc hl
 ENDIF
   pop bc
   ld a,b
   or c
   jr nz,loop
ELSE
   ldi
   dec hl
   ld (hl),a
   inc hl
   jp pe, loop
ENDIF

   pop hl
   ret
