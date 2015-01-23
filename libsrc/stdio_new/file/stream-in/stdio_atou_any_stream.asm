; stdio_atou_any_stream
; 05.2008 aralbrec

PUBLIC stdio_atou_any_stream
EXTERN stdio_getchar, stdio_ungetchar, l_mult, asm_toupper

; read unsigned number from stream, whitespace not skipped
;
; enter :  e = radix
;         ix  = FILE *
; exit  : hl = unsigned int result
; uses  : af, bc, d, hl

.stdio_atou_any_stream

   ld hl,0                     ; hl = result = 0
   ld d,h                      ; de = radix
   
.loop

   call stdio_getchar
   ret c
   
   ; is it a (any-base) digit
   
   ld c,a
   sub '0'
   jr c, exit
   cp 10
   jr c, digit
   add a,'0'
   call asm_toupper
   sub 'A'
   jr c, exit
   add a,10

.digit

   cp e                        ; no good if digit exceeds radix
   jr nc, exit

   push af
   call l_mult                 ; hl *= de, num *= radix
   pop af
   
   add a,l
   ld l,a
   jp nc, loop
   inc h
   jp loop

.exit

   ld a,c
   jp stdio_ungetchar
