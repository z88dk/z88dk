; stdio_numprec
; 05.2008 aralbrec

PUBLIC stdio_numprec
EXTERN stdio_utoa_any

INCLUDE "../stdio.def"

; outputs unsigned integer to string buffer taking precision into account
;
; enter :  a = precision
;          b = num chars in buffer
;          c = radix
;         de = number
;         hl = & next free position in destination buffer
; exit  :  b = num chars in buffer
;         hl = & next free position in destination buffer
; uses  : af, b, de, hl

.stdio_numprec

   cp STDIO_MAXPRECISION + 1   ; limit precision to protect buffer
   jr c, precok
   ld a,STDIO_MAXPRECISION

.precok

   add a,b
   push af                     ; save precision

   cp b                        ; zero precision?
   jr nz, notzeroprec

   ld a,d                      ; special case: zero precison and integer == 0 means don't print number
   or e
   jr z, skipoutput

.notzeroprec

   ;     b = num chars in buffer
   ;     c = radix
   ;    de = number
   ;    hl = & destination buffer
   
   call stdio_utoa_any         ; write unsigned integer into buffer

.skipoutput

   pop af                      ; a = precision

.handleprec

   sub b                       ; is precision requirement satisfied?
   ret c                       ; precision satisfied, all done

.precloop                      ; if not add leading zeroes before the sign

   or a
   ret z
   
   ld (hl),'0'
   dec hl
   inc b
   dec a

   jp precloop
