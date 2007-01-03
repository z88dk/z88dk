; int memcmp(void *s1, void *s2, size_t size)
; compare first n chars of s1 and s2
; 11.1999 djm, 12.2006 aralbrec

; exit : if s==ct : hl = 0, Z flag set
;        if s<<ct : hl < 0, NC flag set
;        if s>>ct : hl > 0, C flag set
; uses : af, bc, de, hl

XLIB memcmp
XDEF ASMDISP_MEMCMP

; not the same as strncmp because there's no '\0' to worry about

.memcmp

   pop af
   pop bc
   pop de
   pop hl
   push hl
   push de
   push bc
   push af
   
   ; bc = int n
   ; de = char *s2
   ; hl = char *s1

.asmentry
   
   ld a,b
   or c
   jr z, equal

.loop

   ld a,(de)
   inc de
   cpi
   jr nz, different
   jp pe, loop
   
.equal

   ld h,b
   ld l,c
   ret

.different

   dec hl
   cp (hl)
   ld h,$80
   ret nc
   dec h
   ret

DEFC ASMDISP_MEMCMP = asmentry - memcmp
