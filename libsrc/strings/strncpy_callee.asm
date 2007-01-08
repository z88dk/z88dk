; char __CALLEE__ *strncpy_callee(char *dst, char *src, uint n)
; copy at most n chars from src to dst not incl '\0' and padding with '\0' if nec
; 04.2001 dom, 12.2006 aralbrec

XLIB strncpy_callee
XDEF ASMDISP_STRNCPY_CALLEE

.strncpy_callee

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

   ld a,b
   or c
   jr z, exit
      
   push de
   
   ; first copy dst into src
   
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

   xor a
   ld (de),a
   pop hl
   ret

.exit

   ex de,hl
   ld (hl),a
   ret

DEFC ASMDISP_STRNCPY_CALLEE = asmentry - strncpy_callee
