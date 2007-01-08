; char __CALEE__ *strncat_callee(char *dst, char *src, uint n)
; copy src to dst but no more than n chars, add '\0'
; 04.2001 dom, 12.2006 aralbrec

XLIB strncat_callee
XDEF ASMDISP_STRNCAT_CALLEE

.strncat_callee

   pop af
   pop bc
   pop hl
   pop de
   push af
   
   ; enter : hl = char *src
   ;         de = char *dst
   ;         bc = uint n
   ; exit  : hl = char *dst
   ; uses  : af, bc, de, hl

.asmentry

   ld a,b
   or c                      ; if n=0 don't do anything
   ret z
   
   push de
   
   ; first find the end of string s1
   
.loop1

   ld a,(de)
   inc de
   or a
   jp nz, loop1
   dec de
   
   ; now append s2 to s1 but no more than n chars

.loop2

   ld a,(hl)
   or a
   jr z, done
   ldi
   jp pe, loop2

   xor a

.done

   ld (de),a
   pop hl
   ret

DEFC ASMDISP_STRNCAT_CALLEE = asmentry - strncat_callee
