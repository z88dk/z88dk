
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
   ret z                       ; if n == 0
   
   xor a

loop:
IF __CPU_GBZ80__
   xor a
ENDIF
   cp (hl)
   ret z                       ; if '\0' met
  
IF __CPU_GBZ80__
   ld a,(hl+)
   ld (de),a
   inc de
   dec bc
   ld a,b
   or c
   jr nz,loop
ELSE 
   ldi
   jp pe, loop
ENDIF

   or a
   ret
