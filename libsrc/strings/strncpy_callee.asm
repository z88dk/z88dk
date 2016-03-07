; char __CALLEE__ *strncpy_callee(char *dst, char *src, uint n)
; copy at most n chars from src to dst and padding with '\0' if nec
; 04.2001 dom, 12.2006 aralbrec

SECTION code_clib
PUBLIC strncpy_callee
PUBLIC _strncpy_callee
PUBLIC ASMDISP_STRNCPY_CALLEE

.strncpy_callee
._strncpy_callee

   pop af
   pop bc
   pop hl
   pop de
   push af
   
   ; enter : de = char *dst
   ;         hl = char *src
   ;         bc = uint n
   ; exit  : hl = char *dst
   ; uses  : af, bc, de, hl
   
.asmentry

   push de

   ld a,b
   or c
   jr z, done
      
   ; first copy src into dst
   
.loopcpy

   ld a,(hl)
   ldi
   jp po, done               ; reached max number of chars
   or a
   jp nz, loopcpy
   
   ; now pad with zeroes
   
   ld l,e
   ld h,d
   dec hl
   ldir

.done

   pop hl
   ret

DEFC ASMDISP_STRNCPY_CALLEE = # asmentry - strncpy_callee
