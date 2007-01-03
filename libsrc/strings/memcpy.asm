; void *memcpy(void *s1, void *s2, size_t n)
; copy n chars from s2 to s1
; 11.1999 djm, 12.2006 aralbrec

; exit : hl = char *s1
; uses : af, bc, de, hl

XLIB memcpy
XDEF ASMDISP_MEMCPY

.memcpy

   pop af
   pop bc
   pop de
   pop hl
   push hl
   push de
   push bc
   push af
   
   ; bc = length
   ; de = src void *s2
   ; hl = dst void *s1

.asmentry

   ld a,b
   or c
   ret z
   
   ; Because of the possibility of overlap between
   ; dst and src, we have two scenarios:
   ; 1 - (dst<src) in which case must ldir
   ; 2 - (dst>src) in which case must lddr from end
   
   ld a,h
   cp d
   jr c, must_ldir
   jr nz, must_lddr
   ld a,l
   cp e
   jr c, must_ldir
   ret z                     ; don't bother if dst=src

.must_lddr

   push hl
   dec bc
   add hl,bc
   ex de,hl
   add hl,bc
   inc bc
   lddr
   pop hl
   ret

.must_ldir

   push hl
   ex de,hl
   ldir
   pop hl
   ret

DEFC ASMDISP_MEMCPY = asmentry - memcpy
