
XLIB asm_vfprintf
XDEF asm_vfprintf_unlocked

LIB asm_strchrnul, l_atou, l_neg_hl, l_jphl
LIB __stdio_nextarg_de, __stdio_send_output_buffer
LIB __stdio_lock_acquire, __stdio_lock_release, __stdio_verify_output

asm_vfprintf:

   ; enter : ix = FILE *
   ;         de = char *format
   ;         bc = void *stack_param
   ;
   ; exit  :
   ;
   ; uses  : all except ix

   call __stdio_lock_acquire
   jp c, error_enolck_mc
   
   call asm_vfprintf_unlocked
   jp __stdio_lock_release

asm_vfprintf_unlocked:

   ; enter : ix = FILE *
   ;         de = char *format
   ;         bc = void *stack_param
   ;
   ; exit  :
   ;
   ; uses  : all except ix

   call __stdio_verify_output  ; check that output on stream is ok
   ret c                       ; if problem with output
   
   








;******************************
; * FORMAT STRING LOOP ********

format_loop:

   ; de = char *format
   ; stack = stack_param
   
   ld l,e
   ld h,d
   
   ld c,'%'
   call asm_strchrnul
   
***jr c, format_end            ; if end of format string reached
   
   ; output format string chars up to '%'
   
   push hl
   
   sbc hl,de
   ld c,l
   ld b,h                      ; bc = num chars to output
   
   ex de,hl                    ; hl = char *format
  
   call nz, __stdio_send_output_buffer
***jr c   ; if stream error
   
   pop de
   ld c,0

;******************************
; * FLAGS FIELD ***************

flags:

   ; consume optional flags "-+ #0"
   ; default flags is none set

   inc de                      ; advance to next char in format string
   
   ; de = address of next format char to examine
   ;  c = conversion_flags
   ; stack = stack_param
      
   ld a,(de)

   ld hl,flag_chars
   ld b,5

flags_id:

   cp (hl)
   inc hl
   
   jr z, flag_found

   inc hl
   djnz flags_id
   
   ld (ix+5),c                 ; store conversion_flags

;******************************
; * WIDTH FIELD ***************

width:

   ; consume optional width specifier
   ; default width is zero

   ;  a = next format char
   ; de = address of next format char to examine
   ; stack = stack_param

   cp '*'
   jr nz, width_from_format
   
   ; asterisk means width comes from parameter list
   
   pop hl
   
   inc de                      ; consume '*'
   push de
   
   ; hl = stack_param
   ; stack = address of next format char to examine
   
   call __stdio_nextarg_de     ; de = width
   ex de,hl

   ; hl = width
   ; de = stack_param
   ; stack = address of next format char to examine
   
   bit 7,h
   jr z, width_positive

   ; negative field width
   
   call l_neg_hl               ; width made positive
   set 2,(ix+5)                ; '-' flag set

width_positive:

   ex (sp),hl
   ex de,hl
   push hl
   
   ; de = address of next format char to examine
   ; stack = width, stack_param

   jr precision

flag_found:

   ld a,(hl)
   
   or c
   ld c,a
   
   jr flags

width_from_format:

   ; read width from format string, default = 0

   ; de = address of next format char to examine
   ; stack = stack_param
   
   call l_atou                 ; hl = width
*** jr c, format_error  ; width out of range

   bit 7,h
*** jr nz, format_error ; width out of range

   ex (sp),hl
   push hl

;******************************
; * PRECISION FIELD ***********

precision:

   ; consume optional precision specifier
   ; default precision is one

   ; de = address of next format char to examine
   ; stack = width, stack_param

   ld hl,1                     ; default precision
   
   ld a,(de)

   cp '.'
   jr nz, end_precision

   set 0,(ix+5)                ; indicate precision is specified
   inc de                      ; consume '.'
   
   ld a,(de)
   cp '*'
   jr nz, precision_from_format
   
   ; asterisk means precision comes from parameter list

   pop hl
   
   inc de                      ; consume '*'
   push de
   
   ; hl = stack_param
   ; stack = width, address of next format char to examine
   
   call __stdio_nextarg_de     ; de = precision
   ex de,hl

   ; hl = precision
   ; de = stack_param
   ; stack = width, address of next format char to examine
   
   bit 7,h
   jr z, precision_positive

   ; negative precision means precision is ignored
   
   ld hl,1                     ; precision takes default value
   res 0,(ix+5)                ; indicate precision is not specified

precision_positive:

   ex (sp),hl
   ex de,hl
   push hl
   
   ; de = address of next format char to examine
   ; stack = width, precision, stack_param

   jr length_modifier

precision_from_format:

   ; read precision from format string

   ; de = address of next format char to examine
   ; stack = width, stack_param

   call l_atou                 ; hl = precision
*** jr c, format_error   ; precision out of range

   bit 7,h
*** jr nz, format_error  ; precision out of range

end_precision:

   ; hl = precision
   ; de = address of next format char to examine
   ; stack = width, stack_param

   ex (sp),hl
   push hl

;******************************
; * LENGTH MODIFIER ***********

length_modifier:

   ; consume optional length modifier

   ; de = address of next format char to examine
   ; stack = width, precision, stack_param

   ld a,(de)

   ld hl,lm_chars
   ld bc,$0600

lm_loop:

   cp (hl)
   inc hl
   
   jr z, lm_found

   inc hl
   djnz lm_loop

;******************************
; * CONVERSION SPECIFIER ******

converter_specifier:

   ; identify conversion "bcdinopsuxIX"

   ; de = address of next format char to examine
   ;  c = length modifier id
   ; stack = width, precision, stack_param

   ld a,(de)
   inc de                      ; consume converter spec
   
   ld b,a                      ; b = conversion spec sought
   ld hl,__PRINTF_CONVERTER_TABLE
  
spec_loop:

   ld a,(hl)
   or a
*** jr z, format_error  ; unrecognized conversion spec

   inc hl
   
   cp b
   jr z, spec_found

   inc hl
   inc hl
   inc hl
   
   jr spec_loop

spec_found:

   ld a,(hl)
   inc hl
   ld h,(hl)
   ld l,a
   
   jp (hl)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

lm_found:

   ld c,(hl)                   ; c = length modifier id
   inc de                      ; consume length modifier

   cp 'l'   
   jr z, lm_double
   
   cp 'h'
   jr nz, converter_specifier

lm_double:

   ld b,a
   ld a,(de)
   
   cp b
   jr nz, converter_specifier
   
   inc de                      ; consume second 'l' or 'h'
   
   ld a,c
   add a,a
   ld c,a
   
   jr converter_specifier

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

flag_chars:

   defb '+', $40
   defb ' ', $20
   defb '#', $10
   defb '0', $08
   defb '-', $04

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

lm_chars:

   defb 'l', __lm_l
   defb 'L', __lm_L
   defb 'h', __lm_h
   defb 'j', __lm_j
   defb 't', __lm_t
   defb 'z', __lm_z

   defc __lm_L = $01
   defc __lm_h = $02
   defc __lm_j = $08
   defc __lm_l = $10
   defc __lm_t = $40
   defc __lm_z = $80
   
   defc __lm_ll = $20
   defc __lm_hh = $04

;******************************
; * PRINTF CONVERTERS *********

__PRINTF_CONVERTER_TABLE:

   defb 'd'
   defw _printf_d
   
   defb 's'
   defw _printf_s

   defb 'c'
   defw _printf_c
   
   defb 'u'
   defw _printf_u
   
   defb 'x'
   defw _printf_x

   defb 'X'
   defw _printf_X
   
   defb 'i'
   defw _printf_i
   
   defb 'n'
   defw _printf_n
   
   defb 'I'
   defw _printf_I
   
   defb 'p'
   defw _printf_p
   
   defb 'o'
   defw _printf_o
   
   defb 'b'
   defw _printf_b
   
   defb 0

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


;;;IN:

   ; de = address of next format char to examine
   ;  c = length modifier id
   ; stack = width, precision, stack_param

;;;OUT:

   ; ix = FILE *
   ; hl = void *stack_param
   ; de = void *buffer_digits
   ; stack = buffer_digits, width, precision

"bcdinopsuxIX"
