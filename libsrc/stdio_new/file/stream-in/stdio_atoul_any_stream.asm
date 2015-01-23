; stdio_atoul_any_stream
; 05.2008 aralbrec

PUBLIC stdio_atoul_any_stream
EXTERN stdio_getchar, stdio_ungetchar, l_long_mult, asm_toupper

; read unsigned long number from stream, whitespace not skipped
;
; enter :    b = radix
;          ix  = FILE *
; exit  : dehl = unsigned int result
; uses  : af, c, de, hl

.stdio_atoul_any_stream

   ld de,0
   ld l,e
   ld h,d                      ; dehl = result = 0

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

   cp b                        ; no good if digit exceeds radix
   jr nc, exit
   ld c,a

   exx                         ; must save alternate set
   push bc                     ; unfortunately inside the loop since
   push de                     ;  stdio_getchar needs them
   push hl
   exx

   push bc                     ; save digit and radix
   push de
   push hl                     ; 32-bit arg1 on stack
   ld de,0
   ld h,d
   ld l,b                      ; dehl = arg2 = radix
   call l_long_mult            ; dehl = arg1*arg2
   pop bc                      ; b = digit, c = radix
   
   exx
   pop hl
   pop de
   pop bc
   exx
   
   ld a,c                      ; add in digit
   add a,l
   ld l,a
   jp nc, loop
   inc h
   jp nz, loop
   inc de
   jp loop

.exit

   ld a,c
   jp stdio_ungetchar
