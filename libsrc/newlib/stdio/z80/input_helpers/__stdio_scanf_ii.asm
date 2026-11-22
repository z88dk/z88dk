
SECTION code_clib
SECTION code_stdio

PUBLIC __stdio_scanf_ii

EXTERN __stdio_scanf_sm_i, __stdio_recv_input_eat_ws_repeat, l_inc_sp
EXTERN __stdio_scanf_sm_ii, __stdio_recv_input_eatc, error_einval_zc, asm__strtoi

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

   ld h,4                      ; octet count
   push hl

   ld a,b
   or c
   jr nz, width_specified
   
   dec bc                      ; consume as many bytes as we want

width_specified:

   push bc                     ; save field width
   push bc                     ; save field width
   
   ; CONSUME LEADING WHITESPACE
   
   call __stdio_recv_input_eat_ws_repeat
      
   ; READ FOUR %i NUMBERS INTO BUFFER, SEPARATE WITH DOTS

   ; de = void *buffer
   ; stack = long *p + 3b, void *buffer, octet count = 4, field width, field width

   ld hl,__stdio_scanf_sm_i    ; use the %i state machine
   jr enter_loop

octet_loop:

   ;  b = octet count
   ; hl = remaining field width
   ; de = void *buffer
   ; stack = long *p + 3b, void *buffer
   
   push bc
   push hl
   push hl

   ; de = void *buffer
   ; stack = long *p + 3b, void *buffer, octet count, field width, field width

   ld hl,__stdio_scanf_sm_ii   ; use the dot + %i state machine

enter_loop:

   ld bc,7                     ; max seven dec/hex/oct digits taken for octet
   
   exx
   
   pop bc                      ; bc = remaining field width
   
   ld a,b
   or c
   jr z, width_exceeded_error
   
   call __stdio_recv_input_eatc
   
   push bc
   
   exx
   
   pop bc                      ; bc = number of bytes read in this operation
   pop hl                      ; hl = remaining field width
   
   jp c, l_inc_sp - 6          ; if stream error, pop three times and exit
   
   sbc hl,bc                   ; hl = updated remaining field width
   
   xor a
   
   ld (de),a                   ; write octet separator
   inc de
   
   pop bc                      ; b = octet count
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
   
   ld c,a
   
   ld a,d
   or e
   jr z, suppressed_1          ; if assignment is suppressed
   
   ld a,c
   
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
   
   ; stack = long *p + 3b, void *buffer, octet count, field width
   
   pop bc
   jp error_einval_zc - 3
