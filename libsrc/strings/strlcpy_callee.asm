; uint __CALLEE__ strlcpy_callee(char *dst, char *src, uint size)
; 06.2008 aralbrec

SECTION code_clib
PUBLIC strlcpy_callee
PUBLIC _strlcpy_callee
PUBLIC ASMDISP_STRLCPY_CALLEE

IF FORrcmx000
EXTERN  rcmx_cpir
ENDIF

.strlcpy_callee
._strlcpy_callee

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

   or a
   jr z, done                  ; if end of src string was reached...
   
   ld a,(hl)
   ldi                         ; copy src byte to dst
   jp pe, cpyloop              ; repeat until size reaches zero

   xor a                       ; one too many bytes copied...
   dec de                      ; need to place \0 into dst
   ld (de),a 
   dec hl                      ; in case last char copied was \0 for cpir following

.szexceeded1

   ;  a = 0
   ; bc = 0

IF FORrcmx000
   call rcmx_cpir
ELSE
   cpir                        ; find end of char *src
ENDIF

.done

   dec hl
 
   ; hl = pointing at \0 at end of char *src
   ; carry flag reset

   pop de                      ; de = char *src
   sbc hl,de                   ; hl = strlen(src)
   ret

defc ASMDISP_STRLCPY_CALLEE = # asmentry - strlcpy_callee
