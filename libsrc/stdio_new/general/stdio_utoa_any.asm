; stdio_utoa_any
; 05.2008 aralbrec

PUBLIC stdio_utoa_any
EXTERN stdio_basechar, l_div_u

; unsigned int to ascii conversion
; string built backwards without terminating '\0'

; enter : hl = & next free position in destination buffer
;         de = unsigned int
;          b = num chars in buffer
;          c = radix
; exit  : hl = & next free position in destination buffer
;          b = num chars in buffer
; uses  : af, b, de, hl

.stdio_utoa_any

   push bc                     ; save count, radix
   push hl                     ; save buffer address
   
   ld l,c
   ld h,0                      ; hl = radix
   call l_div_u                ; hl = num / radix, de = num % radix
   
   ld c,l
   ld b,h                      ; bc = quotient
   
   ld hl,stdio_basechar
   add hl,de
   ld a,(hl)                   ; a = ascii digit
   
   pop hl
   ld (hl),a                   ; write digit to buffer
   dec hl
   
   ld e,c
   ld d,b                      ; de = unsigned int remaining
   pop bc
   
   inc b                       ; count++
   
   ld a,d
   or e
   jp nz, stdio_utoa_any
   
   ret
