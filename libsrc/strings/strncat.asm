; char *strncat(char *s1, char *s2, int n)
; copy string s2 to s1 but no more than n chars, add '\0'
; 12.2006 aralbrec

; exit : hl = char *s1
; uses : af, bc, de, hl

XLIB strncat
XDEF ASMDISP_STRNCAT

.strncat

   pop af
   pop bc
   pop hl
   pop de
   push de
   push hl
   push bc
   push af
   
   ; hl = source char *s2
   ; de = dest char *s1
   ; bc = int n

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

.done

   xor a
   ld (de),a
   pop hl
   ret

DEFC ASMDISP_STRNCAT = asmentry - strncat
