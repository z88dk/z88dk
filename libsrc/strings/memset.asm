; void *memset(void *s, char c, int n)
; write c into first n chars of s
; 04.2001 djm, 12.2006 aralbrec

; exit : hl = char *s
; uses : af, bc, de, hl

XLIB memset
XDEF ASMDISP_MEMSET

.memset

   pop af
   pop bc
   pop de
   pop hl
   push hl
   push de
   push bc
   push af
   
   ; hl = void *s
   ;  e = char c
   ; bc = int n

.asmentry

   ld a,b
   or c
   ret z
   
   ld (hl),e
   dec bc
   ld a,b
   or c
   ret z
   
   push hl
   ld e,l
   ld d,h
   inc de
   ldir
   pop hl

   ret

DEFC ASMDISP_MEMSET = asmentry - memset
