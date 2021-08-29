
; ===============================================================
; Jan 2014
; ===============================================================
; 
; char *_memstrcpy(void *p, char *s, size_t n)
;
; At most n chars from string s are copied to p.  The terminating
; '\0' in s is not copied.
;
; ===============================================================

SECTION code_clib
SECTION code_string

PUBLIC asm__memstrcpy

asm__memstrcpy:

   ; enter : de = void *p = dst
   ;         hl = char *s = src
   ;         bc = size_n
   ;
   ; exit  : de = void *p_ptr = addr of byte following last write
   ;         hl = char *s_ptr = addr of byte following last read
   ;         bc = n remaining
   ;         carry reset
   ;
   ; uses  : af, bc, de, hl
   
   ld a,b
   or c
   ret Z                       ; if n == 0

   xor a

IF __CPU_8085__
   dec bc
ENDIF

loop:
IF __CPU_INTEL__ || __CPU_GBZ80__
   xor a
   cp (hl)
   jp Z,exit                   ; if '\0' met

IF __CPU_GBZ80__
   ld a,(hl+)
ELSE
   ld a,(hl)
   inc hl
ENDIF

   ld (de),a
   inc de
   dec bc

IF __CPU_8085__
   jp NK,loop
ELSE
   ld a,b
   or c
   jp NZ,loop
ENDIF

ELSE 
   ldi
   jp PE, loop
ENDIF

exit:
   inc bc
   or a
   ret

