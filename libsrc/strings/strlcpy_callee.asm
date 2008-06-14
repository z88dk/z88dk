; uint __CALLEE__ strlcpy_callee(char *dst, char *src, uint size)
; 06.2008 aralbrec

XLIB strlcpy_callee
XDEF ASMDISP_STRLCPY_CALLEE

.strlcpy_callee

   pop af
   pop bc
   pop hl
   pop de
   push af

.asmentry

   ; enter : hl = char *src
   ;         de = char *dst
   ;         bc = uint size
   
   push hl                     ; save src to compute strlen later
   
   ld a,b
   or c
   jr z, szexceeded1
   
.cpyloop

   ld a,(hl)
   ldi                         ; copy src byte to dst
   or a
   jr z, done                  ; if end of src string reached...
   jp pe, cpyloop              ; repeat until size reaches zero

   xor a                       ; one too many bytes copied...
   dec de                      ; need to place \0 into dst
   ld (de),a

.szexceeded1

   ;  a = 0
   ; bc = 0

   cpir                        ; find end of char *src
 
.done

   ; hl = one byte past \0 in char *src
   
   pop de                      ; de = char *src
   scf
   sbc hl,de                   ; hl = strlen(src)
   ret

defc ASMDISP_STRLCPY_CALLEE = asmentry - strlcpy_callee
