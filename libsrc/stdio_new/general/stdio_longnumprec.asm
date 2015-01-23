; stdio_longnumprec
; 05.2008 aralbrec

PUBLIC stdio_longnumprec
EXTERN stdio_ultoa_any

INCLUDE "../stdio.def"

; outputs unsigned long to string buffer taking precision into account
;
; enter :  a = precision
;          b = num chars in buffer
;          c = radix
;       dehl = number
;         ix = & next free position in destination buffer
; exit  :  b = num chars in buffer
;         ix = & next free position in destination buffer
; uses  : af, b, de, hl, ix

.stdio_longnumprec

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
   or h
   or l
   jr z, skipoutput

.notzeroprec

   ;     b = num chars in buffer
   ;     c = radix
   ;  dehl = number
   ;    ix = & destination buffer
   
   exx                         ; must save the alternate set as they are reserved for the output function
   push bc
   push de
   push hl
   exx
   
   call stdio_ultoa_any        ; write unsigned long into buffer

   exx                         ; restore alternate set
   pop hl
   pop de
   pop bc
   exx

.skipoutput

   pop af                      ; a = precision

.handleprec

   sub b                       ; is precision requirement satisfied?
   ret c                       ; precision satisfied, all done

.precloop                      ; if not add leading zeroes before the sign

   or a
   ret z
   
   ld (ix+0),'0'
   dec ix
   inc b
   dec a

   jp precloop
