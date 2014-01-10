
; ===============================================================
; Jan 2014
; ===============================================================
; 
; int vfprintf(FILE *stream, const char *format, void *arg)
;
; See C11 specification.
;
; ===============================================================

XLIB asm_vfprintf
XDEF asm_vfprintf_unlocked

LIB asm_strchrnul, l_atou, l_neg_hl, l_jphl, l_utod_hl
LIB __stdio_nextarg_de, __stdio_send_output_buffer
LIB __stdio_lock_acquire, __stdio_lock_release, __stdio_verify_output
LIB error_enolck_mc, error_erange_zc, error_einval_zc

asm_vfprintf:

   ; enter : ix = FILE *
   ;         de = char *format
   ;         bc = void *stack_param = arg
   ;
   ; exit  : ix = FILE *
   ;         de = char *format (next unexamined char)
   ;
   ;         success
   ;
   ;            hl = number of chars output on stream
   ;            carry reset
   ;
   ;         fail
   ;
   ;            hl = - (chars output + 1) < 0
   ;            carry set, errno set as below
   ;
   ;            enolck = stream lock could not be acquired
   ;            eacces = stream not open for writing
   ;            eacces = stream is in an error state
   ;            erange = width or precision out of range
   ;            einval = unknown printf conversion
   ;
   ;            more errors may be set by underlying driver
   ;            
   ; uses  : all except ix

   call __stdio_lock_acquire
   jp c, error_enolck_mc
   
   call asm_vfprintf_unlocked
   jp __stdio_lock_release

asm_vfprintf_unlocked:

   ; enter : ix = FILE *
   ;         de = char *format
   ;         bc = void *stack_param = arg
   ;
   ; exit  : ix = FILE *
   ;         de = char *format (next unexamined char)
   ;
   ;         success
   ;
   ;            hl = number of chars output on stream
   ;            carry reset
   ;
   ;         fail
   ;
   ;            hl = - (chars output + 1) < 0
   ;            carry set, errno set as below
   ;
   ;            enolck = stream lock could not be acquired
   ;            eacces = stream not open for writing
   ;            eacces = stream is in an error state
   ;            erange = width or precision out of range
   ;            einval = unknown printf conversion
   ;
   ;            more errors may be set by underlying driver
   ;            
   ; uses  : all except ix

   call __stdio_verify_output  ; check that output on stream is ok
   ret c                       ; if output on stream not possible

   ld hl,-44
   add hl,sp
   ld sp,hl                    ; create 44 bytes of workspace

   push bc
   
;******************************
; * FORMAT STRING LOOP ********

format_loop:

   ; de = char *format
   ; stack = WORKSPACE_44, stack_param
   
   ld l,e
   ld h,d

_format_loop:

   ld c,'%'
   call asm_strchrnul
   
   ; output format string chars up to '%'
   
   push hl
   
   sbc hl,de
   ld c,l
   ld b,h                      ; bc = num chars to output
   
   ex de,hl                    ; hl = char *format
  
   call nz, __stdio_send_output_buffer
   
   pop de
   jp c, error_stream          ; if stream error
   
   ; de = address of format char stopped on ('%' or '\0')
   ; stack = WORKSPACE_44, stack_param

   ld a,(de)
   or a
   jr z, format_end            ; if stopped on string terminator
   
   inc de                      ; next format char to examine
   
   ld a,(de)
   cp '%'
   jr nz, interpret
   
   ; %%
   
   ld l,e
   ld h,d
   
   inc hl                      ; next char to examine is past %%
   jr _format_loop

format_end:

   ; de = address of format char '\0'
   ; stack = WORKSPACE_44, stack_param

   ld hl,46
   add hl,sp
   ld sp,hl                    ; repair stack
   
   exx
   push hl
   exx
   pop hl                      ; hl = number of chars output
   
   jp l_utod_hl                ; hl = max $7fff

interpret :

   dec de
   ld c,0

;******************************
; * FLAGS FIELD ***************

flags:

   ; consume optional flags "-+ #0"
   ; default flags is none set

   inc de                      ; advance to next char in format string
   
   ; de = address of next format char to examine
   ;  c = conversion_flags
   ; stack = WORKSPACE_44, stack_param
      
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
   ; stack = WORKSPACE_44, stack_param

   cp '*'
   jr nz, width_from_format
   
   ; asterisk means width comes from parameter list
   
   pop hl
   
   inc de                      ; consume '*'
   push de
   
   ; hl = stack_param
   ; stack = WORKSPACE_44, address of next format char to examine
   
   call __stdio_nextarg_de     ; de = width
   ex de,hl

   ; hl = width
   ; de = stack_param
   ; stack = WORKSPACE_44, address of next format char to examine
   
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
   ; stack = WORKSPACE_44, width, stack_param

   jr precision

flag_found:

   ld a,(hl)
   
   or c
   ld c,a
   
   jr flags

width_from_format:

   ; read width from format string, default = 0

   ; de = address of next format char to examine
   ; stack = WORKSPACE_44, stack_param
   
   call l_atou                 ; hl = width
   jp c, error_format_width    ; width out of range

   bit 7,h
   jp nz, error_format_width   ; width out of range

   ex (sp),hl
   push hl

;******************************
; * PRECISION FIELD ***********

precision:

   ; consume optional precision specifier
   ; default precision is one

   ; de = address of next format char to examine
   ; stack = WORKSPACE_44, width, stack_param

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
   ; stack = WORKSPACE_44, width, stack_param

   call l_atou                   ; hl = precision
   jr c, error_format_precision  ; precision out of range

   bit 7,h
   jp nz, error_format_precision ; precision out of range

end_precision:

   ; hl = precision
   ; de = address of next format char to examine
   ; stack = WORKSPACE_44, width, stack_param

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
   ld b,6

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
   ; long modifies "bdinopuxX" not "csI"
   
   ; de = address of next format char to examine
   ;  a = length modifier id
   ; stack = WORKSPACE_44, width, precision, stack_param

   and lm_l + lm_ll            ; only pay attention to long modifier

   ld a,(de)                   ; a = specifier
   inc de

   jr nz, long_spec            ; if long modifier selected

   ; no long modifier

   cp 'd'
   jp z, _printf_d

   cp 'u'
   jp z, _printf_u

   cp 'x'
   jp z, _printf_x
   
   cp 'X'
   jp z, _printf_X
   
   cp 'o'
   jp z, _printf_o
   
   cp 'n'
   jp z, _printf_n
   
   cp 'i'
   jp z, _printf_d             ; %i is the same as %d 
   
   cp 'p'
   jr z, _printf_p
   
   cp 'b'
   jp z, _printf_b

more_spec:

   ; converters unaffected by long modifier (in this implementation)

   cp 's'
   jp z, _printf_s
   
   cp 'c'
   jp z, _printf_c
   
   cp 'I'
   jp z, _printf_I
   
error_spec_unknown:

   ; de = address of next format char to examine
   ; stack = WORKSPACE_44, width, precision, stack_param

   call error_einval_zc        ; set errno
   
   ld hl,50
   jp _error_stream

long_spec:

   cp 'd'
   jp z, _printf_ld

   cp 'u'
   jp z, _printf_lu

   cp 'x'
   jp z, _printf_lx
   
   cp 'X'
   jp z, _printf_lX
   
   cp 'o'
   jp z, _printf_lo
   
   cp 'n'
   jp z, _printf_ln
   
   cp 'i'
   jp z, _printf_ld            ; %i is the same as %d
   
   cp 'p'
   jr z, _printf_lp
   
   cp 'b'
   jp z, _printf_lb

   jr more_spec
   
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

   ; for all printf converter entry points
   ;
   ; de = address of next format char to examine
   ;  c = length modifier id
   ; stack = WORKSPACE_44, width, precision, stack_param

   ; WORSPACE_44 low to high addresses
   ;
   ; offset  size  purpose
   ;
   ;   0       2   void *buffer_digits
   ;   2       2   return address following printf conversion
   ;   4       2   void *stack_param
   ;   6       2   address of next format char
   ;   8       3   prefix buffer space for printf conversion
   ;  11      33   void *buffer_digits (space for printf conversion)

   ; bcdinopsuxIX

_printf_b:

   LIB __stdio_printf_b
   
   res 4,(ix+5)                ; base indicator off

   ld hl,__stdio_printf_b   
   jp printf_invoke_2 - 1

_printf_lb:

   LIB __stdio_printf_lb

   res 4,(ix+5)                ; base indicator off

   ld hl,__stdio_printf_lb
   jp printf_invoke_4 - 1

_printf_c:

   LIB __stdio_printf_c

   ld hl,__stdio_printf_c
   jp printf_invoke_2 - 1

_printf_d:

   LIB __stdio_printf_d

   res 4,(ix+5)                ; base indicator off

   ld a,$40                    ; signed
   ld hl,__stdio_printf_d
   jp printf_invoke_2

_printf_ld:

   LIB __stdio_printf_ld

   res 4,(ix+5)                ; base indicator off
   
   ld a,$40                    ; signed
   ld hl,__stdio_printf_ld
   jp printf_invoke_4

_printf_n:

   LIB __stdio_printf_n

   ld hl,__stdio_printf_n
   jp printf_invoke_2 - 1

_printf_ln:

   LIB __stdio_printf_ln

   ld hl,__stdio_printf_ln
   jp printf_invoke_4 - 1

_pritnf_o:

   LIB __stdio_printf_o

   ld hl,__stdio_printf_o
   jp printf_invoke_2 - 1

_printf_lo:

   LIB __stdio_printf_lo

   ld hl,__stdio_printf_lo
   jp printf_invoke_4 - 1

_printf_p:

   LIB __stdio_printf_p

   ld hl,__stdio_printf_p
   jp printf_invoke_2 - 1

_printf_lp:

   LIB __stdio_printf_lp

   ld hl,__stdio_printf_lp
   jp printf_invoke_4 - 1

_printf_s:

   LIB __stdio_printf_s
 
   ld hl,__stido_printf_s
   jp printf_invoke_2 - 1

_printf_u:

   LIB __stdio_printf_u

   res 4,(ix+5)                ; base indicator off

   ld hl,__stdio_printf_u   
   jp printf_invoke_2 - 1

_printf_lu:

   LIB __stdio_printf_lu

   res 4,(ix+5)                ; base indicator off

   ld hl,__stdio_printf_lu
   jp printf_invoke_4 - 1

_printf_X:

   LIB __stdio_printf_x

   ld a,$80                    ; capitalize
   ld hl,__stdio_printf_x
   jp printf_invoke_2
   
_printf_lX:

   LIB __stdio_printf_lx
      
   ld a,$80                    ; capitalize
   ld hl,__stdio_printf_lx
   jp printf_invoke_4

_printf_x:

   LIB __stdio_printf_x

   ld hl,__stdio_printf_x
   jp printf_invoke_2 - 1

_printf_lx:

   LIB __stdio_printf_lx

   ld hl,__stdio_printf_lx
   jp printf_invoke_4 - 1

_printf_I:

   LIB __stdio_printf_ii

   ld hl,__stdio_printf_ii
   jp printf_invoke_4 - 1

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

   xor a

printf_invoke_4:

   ld (ix+4),a                 ; signed / unsigned / capitalize
   ld bc,printf_return_4

   jr printf_invoke

   xor a

printf_invoke_2:

   ld (ix+4),a                 ; signed / unsigned / capitalize
   ld bc,printf_return_2

printf_invoke:

   ; hl = & printf_converter
   ; de = address of next format char to examine
   ; bc = return address after printf conversion
   ; stack = WORKSPACE_44, width, precision, stack_param

   ex (sp),hl                  ; push & printf_converter
   push hl

   ld hl,13
   add hl,sp
   
   ld (hl),d
   dec hl
   ld (hl),e                   ; store address of next format char
   dec hl
   
   pop de                      ; de = stack_param
   
   ld (hl),d
   dec hl
   ld (hl),e                   ; store stack_param
   dec hl
   
   ld (hl),b
   dec hl
   ld (hl),c                   ; store return address after printf
   dec hl
   
   ld c,l
   ld b,h
   
   ld hl,10
   add hl,bc                   ; hl = buffer_digits
   
   ld a,h
   ld (bc),a
   dec bc
   ld a,l
   ld (bc),a                   ; store buffer_digits
   
   ex de,hl
   
   ; ix = FILE *
   ; hl = void *stack_param
   ; de = void *buffer_digits
   ; stack = WORKSPACE_42, buffer_digits, width, precision, & printf_conv
   
   ret

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

printf_return_4:

   ; printf converters that read four bytes from stack_param return here
   ;
   ; carry set if error
   ; stack = WORKSPACE_36, char *format, void *stack_param

   pop bc
   
   dec bc
   dec bc                      ; bc = stack_param += 2
   
   jr _return_join

printf_return_2:

   ; printf converters that read two bytes from stack_param return here
   ;
   ; carry set if error
   ; stack = WORKSPACE_36, char *format, void *stack_param

   pop bc

_return_join:

   dec bc
   dec bc                      ; bc = stack_param += 2
   
   pop de                      ; de = char *format
   
   jr c, error_printf_converter
   
   ld hl,-8
   add hl,sp
   ld sp,hl
   
   push bc
   
   ; format_loop expects this:
   ;
   ; de = char *format
   ; stack = WORKSPACE_44, stack_param

   jp format_loop

;******************************
; * ERRORS ********************

error_format_precision:

   ; de = address of next format char to examine
   ; stack = WORKSPACE_44, width, stack_param

   pop bc                      ; junk one item
   
   ; fall through

error_format_width:

   ; de = address of next format char to examine
   ; stack = WORKSPACE_44, stack_param

   call error_erange_zc        ; set errno

   ; fall through

error_stream:

   ; de = address of format char stopped on ('%' or '\0')
   ; stack = WORKSPACE_44, stack_param

   ld hl,46
 
_error_stream:

   add hl,sp
   ld sp,hl                    ; repair stack

   exx
   push hl
   exx
   pop hl                      ; hl = number of chars transmitted

   call l_utod_hl              ; hl = max $7fff

   inc hl
   call l_neg_hl               ; hl = - (chars out + 1) < 0

   scf                         ; indicate error
   ret

error_printf_converter:

   ; de = address of next format char to examine
   ; stack = WORKSPACE_36

   ld hl,36
   jr _error_stream
