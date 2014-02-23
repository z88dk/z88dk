
XLIB __stdio_scanf_ii

LIB __stdio_scanf_sm_i, __stdio_scanf_number_head, l_inc_sp, __stdio_scanf_sm_ii
LIB __stdio_recv_input_eatc, error_einval_zc, asm__strtoi

__stdio_scanf_ii:

   ; %I converter called from vfscanf()
   ; non-standard, reads IPv4 dotted decimal address into host order long
   ;
   ; enter : ix = FILE *
   ;         de = void *buffer
   ;         bc = field width (0 means default)
   ;         hl = long *p
   ;
   ; exit  : carry set if error
   ;
   ; uses  : all except ix

   ld a,h
   or l
   jr z, suppressed_0          ; if assignment is suppressed

   inc hl
   inc hl
   inc hl

suppressed_0:
   
   push hl                     ; save long *p + 3b
   push de                     ; save void *buffer

   ; READ FOUR %i NUMBERS INTO BUFFER, SEPARATE WITH DOTS
      
   ld a,7                      ; max seven dec/hex/oct digits taken for octet
   ld hl,__stdio_scanf_sm_i    ; use the dec/hex/oct state machine
   
   call __stdio_scanf_number_head  ; skip leading whitespace and read first octet string
   jp c, l_inc_sp - 4          ; if stream error, pop twice and exit

   inc de

   ; de = void *buffer_ptr (address after last char written)
   ; bc'= field width
   ; hl'= next unconsumed stream char
   ; stack = long *p + 3b, void *buffer

   ld b,3                      ; repeat three times

octet_loop:

   push bc                     ; save loop count
    
   ld bc,7                     ; max seven dec/hex/oct digits taken for octet
   ld hl,__stdio_scanf_sm_ii   ; use dot + the dec/hex/oct state machine
   
   exx

   ld a,b
   or c
   jr z, width_exceeded_error  ; if remaining field width is zero

   call __stdio_recv_input_eatc

   exx
   pop bc                      ; b = loop count

   jp c, l_inc_sp - 4          ; if stream error, pop twice and exit
   
   xor a
   ld (de),a                   ; write octet separator
   
   inc de
   djnz octet_loop

   ; CONVERT THE DOTTED DECIMAL IPv4 ADDRESS IN THE BUFFER
   
   ; stack = long *p + 3b, void *buffer

   pop hl                      ; hl = void *buffer
   pop de                      ; de = long *p + displacement

   ld b,4                      ; four octets to convert

conversion_loop:

   push bc
   push de
   
   call convert_octet
   
   ex de,hl                    ; hl = void *buffer_ptr
   inc hl                      ; move past dot
   
   pop de                      ; de = long *p + displacement
   pop bc                      ;  b = loop count

   jp c, error_einval_zc       ; if conversion error
   
   ld a,d
   or e
   jr z, suppressed_1          ; if assignment is suppressed
   
   ld (de),a                   ; write byte to long *p
   dec de

suppressed_1:

   djnz conversion_loop        ; repeat for four octets
   
   ld a,d
   or e
   ret z                       ; if assignment is suppressed
   
   exx
   inc hl                      ; num items assigned++
   exx

   ret

convert_octet:

   ; enter : hl = void *buffer
   ; exit  :  a = octet
   ;       ; de = void *buffer_ptr (next char to examine)

   ld bc,0                     ; auto select base
   ld e,c
   ld d,c                      ; de = char **endp = 0
   
   call asm__strtoi
   ret c                       ; if conversion failure
   
   ld a,h
   or a

   ld a,l
   ret z
   
   scf                         ; if octet out of range
   ret

width_exceeded_error:

   exx
   
   ; stack = long *p + 3b, void *buffer, loop count
   
   pop bc
   pop bc
   
   jp error_einval_zc - 1
