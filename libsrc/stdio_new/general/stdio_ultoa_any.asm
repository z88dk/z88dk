; stdio_ultoa_any
; 05.2008 aralbrec

PUBLIC stdio_ultoa_any
EXTERN l_long_div_u, stdio_basechar

; unsigned long to ascii conversion
; string built backwards without terminating '\0'

; enter :  b = num chars in buffer
;          c = radix
;         ix = & next free position in destination buffer
;       dehl = unsigned long n
; exit  :  b = num chars in buffer
;         ix = & next free position in destination buffer
; uses  : af, b, de, hl, ix, bc', de', hl'

.stdio_ultoa_any

   push bc                     ; save num chars, radix
   
   push de
   push hl                     ; arg1 = n on stack
   ld de,0
   ld h,d
   ld l,c                      ; arg2 = dehl = radix
   call l_long_div_u           ; dehl = n/radix, de'hl' = num % radix
   
   exx
   ld de,stdio_basechar
   add hl,de
   ld a,(hl)                   ; get char to output
   exx
   
   ld (ix+0),a                 ; write into buffer
   dec ix
   
   pop bc                      ; b = num chars, c = radix
   inc b
   
   ld a,d
   or e
   or h
   or l
   jp nz, stdio_ultoa_any

   ret
