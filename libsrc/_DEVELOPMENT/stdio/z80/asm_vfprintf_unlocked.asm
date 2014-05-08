
; ===============================================================
; Jan 2014
; ===============================================================
; 
; int vfprintf_unlocked(FILE *stream, const char *format, void *arg)
;
; See C11 specification.
;
; ===============================================================

INCLUDE "clib_cfg.asm"

PUBLIC asm_vfprintf_unlocked
PUBLIC asm0_vfprintf_unlocked, asm1_vfprintf_unlocked

EXTERN __stdio_verify_output, asm_strchrnul, __stdio_send_output_buffer
EXTERN l_utod_hl, l_neg_hl, error_einval_zc


IF __CLIB_OPT_PRINTF != 0

EXTERN __stdio_nextarg_de, l_atou, __stdio_length_modifier, error_erange_zc

ENDIF


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
   ;            eacces = stream not open for writing
   ;            eacces = stream is in an error state
   ;            erange = width or precision out of range
   ;            einval = unknown printf conversion
   ;
   ;            more errors may be set by underlying driver
   ;            
   ; uses  : all except ix

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
IF __CLIB_OPT_STDIO & $01

   EXTERN __stdio_verify_valid

   call __stdio_verify_valid
   ret c

ENDIF
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

asm1_vfprintf_unlocked:

   call __stdio_verify_output  ; check that output on stream is ok
   ret c                       ; if output on stream not possible

asm0_vfprintf_unlocked:

IF __CLIB_OPT_PRINTF != 0

   ld hl,-44
   add hl,sp
   ld sp,hl                    ; create 44 bytes of workspace

   push bc

ENDIF
   
   exx
   ld hl,0                     ; initial output count is zero
   exx
   
;******************************
; * FORMAT STRING LOOP ********

format_loop:

   ; de = char *format
   ; stack = WORKSPACE_44, stack_param
   
   ld l,e
   ld h,d

__format_loop:

   ld c,'%'
   call asm_strchrnul
   
   ; output format string chars up to '%'
   
   push hl
   
   or a
   sbc hl,de
   ld c,l
   ld b,h                      ; bc = num chars to output
   
   ex de,hl                    ; hl = char *format
  
   call nz, __stdio_send_output_buffer
   
   pop de


IF __CLIB_OPT_PRINTF = 0

   jr c, error_stream          ; if stream error

ELSE

   jp c, error_stream          ; if stream error

ENDIF
   
   
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
   jr __format_loop

format_end:

   ; de = address of format char '\0'
   ; stack = WORKSPACE_44, stack_param

IF __CLIB_OPT_PRINTF != 0

   ld hl,46
   add hl,sp
   ld sp,hl                    ; repair stack

ENDIF
   
   exx
   push hl
   exx
   pop hl                      ; hl = number of chars output
   
   or a
   jp l_utod_hl                ; hl = max $7fff

; * AA ********************************************************

IF __CLIB_OPT_PRINTF = 0

   ; completely disable % logic
   ; printf can only be used to output format text
   
interpret:
   
   ; de = address of format char after '%'

   call error_einval_zc
;;;;   jr error_stream             ; could probably just fall through but let's be safe

ENDIF

; * BB ********************************************************

IF __CLIB_OPT_PRINTF != 0

   ; regular % processing

flag_chars:

   defb '+', $40
   defb ' ', $20
   defb '#', $10
   defb '0', $08
   defb '-', $04

interpret:

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
   ; stack = WORKSPACE_44, width, address of next format char to examine
   
   call __stdio_nextarg_de     ; de = precision
   ex de,hl

   ; hl = precision
   ; de = stack_param
   ; stack = WORKSPACE_44, width, address of next format char to examine
   
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
   ; stack = WORKSPACE_44, width, precision, stack_param

   jr length_modifier

precision_from_format:

   ; read precision from format string

   ; de = address of next format char to examine
   ; stack = WORKSPACE_44, width, stack_param

   call l_atou                   ; hl = precision
   jp c, error_format_precision  ; precision out of range

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
   ; stack = WORKSPACE_44, width, precision, stack_param

   call __stdio_length_modifier

;******************************
; * CONVERSION SPECIFIER ******

converter_specifier:

   ; identify conversion "BcdinopsuxIX"
   ; long modifies "BdinopuxX" not "csI"
   
   ; de = address of next format char to examine
   ;  c = length modifier id
   ; stack = WORKSPACE_44, width, precision, stack_param

   ld a,c
   and $30                     ; only pay attention to long modifier

   ld a,(de)                   ; a = specifier
   inc de

   jr nz, long_spec            ; if long modifier selected

   ; no long modifier

IF __CLIB_OPT_PRINTF & $01

   cp 'd'
   jr z, _printf_d

ENDIF

IF __CLIB_OPT_PRINTF & $02

   cp 'u'
   jp z, _printf_u

ENDIF

IF __CLIB_OPT_PRINTF & $04

   cp 'x'
   jp z, _printf_x

ENDIF

IF __CLIB_OPT_PRINTF & $08
   
   cp 'X'
   jp z, _printf_xx

ENDIF

IF __CLIB_OPT_PRINTF & $10
   
   cp 'o'
   jp z, _printf_o

ENDIF

IF __CLIB_OPT_PRINTF & $20
   
   cp 'n'
   jr z, _printf_n

ENDIF

IF __CLIB_OPT_PRINTF & $40
   
   cp 'i'
   jr z, _printf_d             ; %i is the same as %d 

ENDIF

IF __CLIB_OPT_PRINTF & $80
   
   cp 'p'
   jp z, _printf_p

ENDIF

IF __CLIB_OPT_PRINTF & $100
   
   cp 'B'
   jr z, _printf_bb

ENDIF

more_spec:

   ; converters unaffected by long modifier (in this implementation)

IF __CLIB_OPT_PRINTF & $200

   cp 's'
   jp z, _printf_s

ENDIF

IF __CLIB_OPT_PRINTF & $400
   
   cp 'c'
   jr z, _printf_c

ENDIF

IF __CLIB_OPT_PRINTF & $800
   
   cp 'I'
   jp z, _printf_I

ENDIF
   
error_spec_unknown:

   ; de = address of next format char to examine
   ; stack = WORKSPACE_44, width, precision, stack_param

   call error_einval_zc        ; set errno
   
   ld hl,50
   jp __error_stream

long_spec:

IF __CLIB_OPT_PRINTF & $1000

   cp 'd'
   jr z, _printf_ld

ENDIF

IF __CLIB_OPT_PRINTF & $2000

   cp 'u'
   jp z, _printf_lu

ENDIF

IF __CLIB_OPT_PRINTF & $4000

   cp 'x'
   jp z, _printf_lx

ENDIF

IF __CLIB_OPT_PRINTF & $8000
   
   cp 'X'
   jp z, _printf_lxx

ENDIF

IF __CLIB_OPT_PRINTF & $10000
   
   cp 'o'
   jr z, _printf_lo

ENDIF

IF __CLIB_OPT_PRINTF & $20000
   
   cp 'n'
   jr z, _printf_ln

ENDIF

IF __CLIB_OPT_PRINTF & $40000
   
   cp 'i'
   jr z, _printf_ld            ; %i is the same as %d

ENDIF

IF __CLIB_OPT_PRINTF & $80000

   cp 'p'
   jr z, _printf_lp

ENDIF

IF __CLIB_OPT_PRINTF & $100000
   
   cp 'B'
   jr z, _printf_lbb

ENDIF

   jr more_spec

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

IF __CLIB_OPT_PRINTF & $100

_printf_bb:

   EXTERN __stdio_printf_bb
   
   res 4,(ix+5)                ; base indicator off
   ld hl,__stdio_printf_bb
   
   jp printf_invoke_2 - 2

ENDIF

IF __CLIB_OPT_PRINTF & $100000

_printf_lbb:

   EXTERN __stdio_printf_lbb

   res 4,(ix+5)                ; base indicator off
   ld hl,__stdio_printf_lbb

   jr printf_invoke_4 - 2

ENDIF

IF __CLIB_OPT_PRINTF & $400

_printf_c:

   EXTERN __stdio_printf_c

   ld hl,__stdio_printf_c
   jr printf_invoke_2 - 2

ENDIF

IF __CLIB_OPT_PRINTF & $41

_printf_d:

   EXTERN __stdio_printf_d

   res 4,(ix+5)                ; base indicator off
   ld a,$c0                    ; signed & capitalize

   ld hl,__stdio_printf_d
   jr printf_invoke_2

ENDIF

IF __CLIB_OPT_PRINTF & $41000

_printf_ld:

   EXTERN __stdio_printf_ld

   res 4,(ix+5)                ; base indicator off
   ld a,$c0                    ; signed & capitalize

   ld hl,__stdio_printf_ld
   jr printf_invoke_4

ENDIF

IF __CLIB_OPT_PRINTF & $20

_printf_n:

   EXTERN __stdio_printf_n

   ld hl,__stdio_printf_n
   jr printf_invoke_2 - 2

ENDIF

IF __CLIB_OPT_PRINTF & $20000

_printf_ln:

   EXTERN __stdio_printf_ln

   ld hl,__stdio_printf_ln
   jr printf_invoke_4 - 2

ENDIF

IF __CLIB_OPT_PRINTF & $10

_printf_o:

   EXTERN __stdio_printf_o

   set 1,(ix+5)                ; octal base indicator
   ld hl,__stdio_printf_o
   
   jr printf_invoke_2 - 2

ENDIF

IF __CLIB_OPT_PRINTF & $10000

_printf_lo:

   EXTERN __stdio_printf_lo

   set 1,(ix+5)                ; octal base indicator
   ld hl,__stdio_printf_lo

   jr printf_invoke_4 - 2

ENDIF

IF __CLIB_OPT_PRINTF & $80

_printf_p:

   EXTERN __stdio_printf_p

   ld hl,__stdio_printf_p
   jr printf_invoke_2 - 2

ENDIF

IF __CLIB_OPT_PRINTF & $80000

_printf_lp:

   EXTERN __stdio_printf_lp

   ld hl,__stdio_printf_lp
   jr printf_invoke_4 - 2
ENDIF

IF __CLIB_OPT_PRINTF & $200

_printf_s:

   EXTERN __stdio_printf_s
 
   ld hl,__stdio_printf_s
   jr printf_invoke_2 - 2

ENDIF

IF __CLIB_OPT_PRINTF & $02

_printf_u:

   EXTERN __stdio_printf_u

   res 4,(ix+5)                ; base indicator off
   ld hl,__stdio_printf_u
   
   jr printf_invoke_2 - 2

ENDIF

IF __CLIB_OPT_PRINTF & $2000

_printf_lu:

   EXTERN __stdio_printf_lu

   res 4,(ix+5)                ; base indicator off
   ld hl,__stdio_printf_lu
   
   jr printf_invoke_4 - 2

ENDIF

IF __CLIB_OPT_PRINTF & $08

_printf_xx:

   EXTERN __stdio_printf_x

   ld hl,__stdio_printf_x
   jr printf_invoke_2 - 2

ENDIF

IF __CLIB_OPT_PRINTF & $8000

_printf_lxx:

   EXTERN __stdio_printf_lx
      
   ld hl,__stdio_printf_lx
   jr printf_invoke_4 - 2

ENDIF

IF __CLIB_OPT_PRINTF & $04

_printf_x:

   EXTERN __stdio_printf_x

   xor a                       ; no capitalize
   ld hl,__stdio_printf_x
   jr printf_invoke_2

ENDIF

IF __CLIB_OPT_PRINTF & $4000

_printf_lx:

   EXTERN __stdio_printf_lx
   
   xor a                       ; no capitalize
   ld hl,__stdio_printf_lx
   jr printf_invoke_4

ENDIF

IF __CLIB_OPT_PRINTF & $800

_printf_I:

   EXTERN __stdio_printf_ii

   ld hl,__stdio_printf_ii
   jr printf_invoke_4 - 2

ENDIF

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

   ld a,$80                    ; capitalize by default

printf_invoke_4:

   ld bc,printf_return_4
   jr printf_invoke

   ld a,$80                    ; capitalize by default

printf_invoke_2:

   ld bc,printf_return_2

printf_invoke:

   ld (ix+4),a                 ; signed / unsigned / capitalize

   ; hl = & printf_converter
   ; de = address of next format char to examine
   ; bc = return address after printf conversion
   ; stack = WORKSPACE_44, width, precision, stack_param

   ex (sp),hl                  ; push & printf_converter
   push hl

   ; de = char *format
   ; bc = return address
   ; stack = WORKSPACE_44, width, precision, & converter, stack_param

   ld hl,15
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

;******************************
IF __SDCC | __SDCC_IX | __SDCC_IY
;******************************

   inc bc
   inc bc                      ; bc = stack_param += 2

;******************************
ELSE
;******************************

   dec bc
   dec bc                      ; bc = stack_param += 2

;******************************   
ENDIF
;******************************

   jr _return_join

printf_return_2:

   ; printf converters that read two bytes from stack_param return here
   ;
   ; carry set if error
   ; stack = WORKSPACE_36, char *format, void *stack_param

   pop bc

_return_join:

;******************************
IF __SDCC | __SDCC_IX | __SDCC_IY
;******************************

   inc bc
   inc bc                      ; bc = stack_param += 2

;******************************
ELSE
;******************************

   dec bc
   dec bc                      ; bc = stack_param += 2

;******************************   
ENDIF
;******************************

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

ENDIF

; ** AA BB ****************************************************
; all clib options have this code

error_stream:

IF __CLIB_OPT_PRINTF != 0

   ; de = address of format char stopped on ('%' or '\0')
   ; stack = WORKSPACE_44, stack_param

   ld hl,46
 
__error_stream:

   add hl,sp
   ld sp,hl                    ; repair stack

ENDIF

   exx
   push hl
   exx
   pop hl                      ; hl = number of chars transmitted

   call l_utod_hl              ; hl = max $7fff
   inc hl
   
   scf                         ; indicate error
   jp l_neg_hl                 ; hl = - (chars out + 1) < 0

IF __CLIB_OPT_PRINTF != 0

error_printf_converter:

   ; de = address of next format char to examine
   ; stack = WORKSPACE_36

   ld hl,36
   jr __error_stream

ENDIF
