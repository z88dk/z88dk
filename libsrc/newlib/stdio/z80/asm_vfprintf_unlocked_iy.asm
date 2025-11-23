
; ===============================================================
; Jan 2014
; ===============================================================
; 
; int vfprintf_unlocked(FILE *stream, const char *format, void *arg)
;
; See C11 specification.
;
; ===============================================================

; not to be included in c library
; dynamic printf for sdcc_iy compiles only

SECTION code_clib
SECTION code_stdio

PUBLIC asm_vfprintf_unlocked
PUBLIC asm0_vfprintf_unlocked, asm1_vfprintf_unlocked

EXTERN __stdio_verify_output, asm_strchrnul, __stdio_send_output_buffer
EXTERN l_utod_hl, l_neg_hl, error_einval_zc
EXTERN __stdio_nextarg_de, l_atou, __stdio_length_modifier, error_erange_zc

asm_vfprintf_unlocked:

   ; enter : iy = FILE *
   ;         de = char *format
   ;         bc = void *stack_param = arg
   ;
   ; exit  : iy = FILE *
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
   ; uses  : all except iy

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

IF (CLIB_OPT_PRINTF != 0) || ((CLIB_OPT_PRINTF_2 != 0) && __SDCC)

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

format_loop_printf:

   ; de = char *format
   ; stack = WORKSPACE_44, stack_param
   
   ld l,e
   ld h,d

__format_loop_printf:

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


IF (CLIB_OPT_PRINTF = 0) && ((CLIB_OPT_PRINTF_2 = 0) || __SCCZ80)

   jr c, error_stream_printf          ; if stream error

ELSE

   jp c, error_stream_printf          ; if stream error

ENDIF
   
   
   ; de = address of format char stopped on ('%' or '\0')
   ; stack = WORKSPACE_44, stack_param

   ld a,(de)
   or a
   jr z, format_end_printf            ; if stopped on string terminator
   
   inc de                      ; next format char to examine
   
   ld a,(de)
   cp '%'
   jr nz, interpret_printf
   
   ; %%
   
   ld l,e
   ld h,d
   
   inc hl                      ; next char to examine is past %%
   jr __format_loop_printf

format_end_printf:

   ; de = address of format char '\0'
   ; stack = WORKSPACE_44, stack_param

IF (CLIB_OPT_PRINTF != 0) || ((CLIB_OPT_PRINTF_2 != 0) && __SDCC)

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

IF (CLIB_OPT_PRINTF = 0) && ((CLIB_OPT_PRINTF_2 = 0) || __SCCZ80)

   ; completely disable % logic
   ; printf can only be used to output format text
   
interpret_printf:
   
   ; de = address of format char after '%'

   call error_einval_zc
;;;;   jr error_stream_printf             ; could probably just fall through but let's be safe

ENDIF

; * BB ********************************************************

IF (CLIB_OPT_PRINTF != 0) || ((CLIB_OPT_PRINTF_2 != 0) && __SDCC)

   ; regular % processing

flag_chars_printf:

   defb '+', $40
   defb ' ', $20
   defb '#', $10
   defb '0', $08
   defb '-', $04

interpret_printf:

   dec de
   ld c,0

;******************************
; * FLAGS FIELD ***************

flags_printf:

   ; consume optional flags "-+ #0"
   ; default flags is none set

   inc de                      ; advance to next char in format string
   
   ; de = address of next format char to examine
   ;  c = conversion_flags
   ; stack = WORKSPACE_44, stack_param
      
   ld a,(de)

   ld hl,flag_chars_printf
   ld b,5

flags_id_printf:

   cp (hl)
   inc hl
   
   jr z, flag_found_printf

   inc hl
   djnz flags_id_printf
   
   ld (iy+5),c                 ; store conversion_flags

;******************************
; * width FIELD ***************

width_printf:

   ; consume optional width specifier
   ; default width is zero

   ;  a = next format char
   ; de = address of next format char to examine
   ; stack = WORKSPACE_44, stack_param

   cp '*'
   jr nz, width_from_format_printf
   
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
   jr z, width_positive_printf

   ; negative field width
   
   call l_neg_hl               ; width made positive
   set 2,(iy+5)                ; '-' flag set

width_positive_printf:

   ex (sp),hl
   ex de,hl
   push hl
   
   ; de = address of next format char to examine
   ; stack = WORKSPACE_44, width, stack_param

   jr precision_printf

flag_found_printf:

   ld a,(hl)
   
   or c
   ld c,a
   
   jr flags_printf

width_from_format_printf:

   ; read width from format string, default = 0

   ; de = address of next format char to examine
   ; stack = WORKSPACE_44, stack_param
   
   call l_atou                 ; hl = width
   jp c, error_format_width_printf    ; width out of range

   bit 7,h
   jp nz, error_format_width_printf   ; width out of range

   ex (sp),hl
   push hl

;******************************
; * precision FIELD ***********

precision_printf:

   ; consume optional precision specifier
   ; default precision is one

   ; de = address of next format char to examine
   ; stack = WORKSPACE_44, width, stack_param

   ld hl,1                     ; default precision
   
   ld a,(de)

   cp '.'
   jr nz, end_precision_printf

   set 0,(iy+5)                ; indicate precision is specified
   inc de                      ; consume '.'
   
   ld a,(de)
   cp '*'
   jr nz, precision_from_format_printf
   
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
   jr z, precision_positive_printf

   ; negative precision means precision is ignored
   
   ld hl,1                     ; precision takes default value
   res 0,(iy+5)                ; indicate precision is not specified

precision_positive_printf:

   ex (sp),hl
   ex de,hl
   push hl
   
   ; de = address of next format char to examine
   ; stack = WORKSPACE_44, width, precision, stack_param

   jr length_modifier_printf

precision_from_format_printf:

   ; read precision from format string

   ; de = address of next format char to examine
   ; stack = WORKSPACE_44, width, stack_param

   call l_atou                   ; hl = precision
   jp c, error_format_precision_printf  ; precision out of range

   bit 7,h
   jp nz, error_format_precision_printf ; precision out of range

end_precision_printf:

   ; hl = precision
   ; de = address of next format char to examine
   ; stack = WORKSPACE_44, width, stack_param

   ex (sp),hl
   push hl

;******************************
; * LENGTH MODIFIER ***********

length_modifier_printf:

   ; consume optional length modifier

   ; de = address of next format char to examine
   ; stack = WORKSPACE_44, width, precision, stack_param

   call __stdio_length_modifier

;******************************
; * CONVERSION SPECIFIER ******

converter_specifier_printf:

   ; identify conversion "aABcdeEfFgGinopsuxIX"
   ; long modifies "BdinopuxX" not "aAceEfFgGsI"
   
   ; de = address of next format char to examine
   ;  c = length modifier id
   ; stack = WORKSPACE_44, width, precision, stack_param

   ld a,(de)                   ; a = specifier
   inc de

IF CLIB_OPT_PRINTF & $800

   cp 'I'
   jr z, printf_I              ; converter does not fit tables

ENDIF

   ld b,a                      ; b = specifier

   ld a,c
   and $30                     ; only pay attention to long and longlong modifiers
   sub $10

   ; carry must be reset here

   jr nc, long_spec_printf            ; if long or longlong modifier selected

   ;;; without long spec

IF CLIB_OPT_PRINTF & $1ff

   ld hl,rcon_tbl_printf              ; converters without long spec
   call match_con_printf
   jr c, printf_return_is_2

ENDIF

common_spec_printf:

IF CLIB_OPT_PRINTF & $600

   ld hl,acon_tbl_printf              ; converters independent of long spec
   call match_con_printf
   jr c, printf_return_is_2

ENDIF

IF CLIB_OPT_PRINTF & $3fc00000

   ld hl,fcon_tbl_printf              ; float converters are independent of long spec
   call match_con_printf

   IF __SDCC | __SDCC_IX | __SDCC_IY
   
      jr c, printf_return_is_4
   
   ELSE
   
      jr c, printf_return_is_6

   ENDIF
   
ENDIF
   
   ;;; converter unrecognized

unrecognized_printf:

   ; de = address of next format char to examine
   ; stack = WORKSPACE_44, width, precision, stack_param

   call error_einval_zc        ; set errno
   
   ld hl,50
   jp __error_stream_printf

IF CLIB_OPT_PRINTF_2 && __SDCC

   ;;; with longlong spec

longlong_spec_printf:

   ld hl,llcon_tbl_printf             ; converters with longlong spec
   call match_con_printf

   jr c, printf_return_is_8
   jr common_spec_printf
      
ENDIF

   ;;; with long spec

long_spec_printf:
   
IF CLIB_OPT_PRINTF_2 && __SDCC

   jr nz, longlong_spec_printf

ELSE

   jr nz, common_spec_printf

ENDIF

IF CLIB_OPT_PRINTF & $1ff000

   ld hl,lcon_tbl_printf              ; converters with long spec
   call match_con_printf

ENDIF

   jr nc, common_spec_printf

   ;;; conversion matched

IF (CLIB_OPT_PRINTF & $1ff800) || ((__SDCC) && (CLIB_OPT_PRINTF & $3fc00000))

printf_return_is_4:

   ld bc,printf_return_4
   jr printf_invoke_flags

ENDIF

IF CLIB_OPT_PRINTF & $800

printf_I:

   EXTERN __stdio_printf_ii

   ld hl,__stdio_printf_ii
   ld a,$80

   jr printf_return_is_4

ENDIF

IF CLIB_OPT_PRINTF_2 && __SDCC

printf_return_is_8:

   ld bc,printf_return_8
   jr printf_invoke_flags

ENDIF

IF (__SCCZ80 | __ASM) && (CLIB_OPT_PRINTF & $3fc00000)

printf_return_is_6:

   ld bc,printf_return_6
   jr printf_invoke_flags

ENDIF

IF CLIB_OPT_PRINTF & $7ff

printf_return_is_2:

   ld bc,printf_return_2

ENDIF

printf_invoke_flags:

   ;  a = invoke flags
   ; hl = & printf converter
   ; bc = return address after conversion
   ; de = address of next format char to examine
   ; stack = WORKSPACE_44, width, precision, stack_param

   bit 5,a
   jr z, skip_00_printf
   set 1,(iy+5)                ; indicates octal conversion

skip_00_printf:

   bit 4,a
   jr z, skip_11_printf
   res 4,(iy+5)                ; suppress base indicator

skip_11_printf:

   and $c0
   ld (iy+4),a                 ; capitalize & signed conversion indicators

printf_invoke:

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
   
   ; iy = FILE *
   ; hl = void *stack_param
   ; de = void *buffer_digits
   ; stack = WORKSPACE_42, return addr, buffer_digits, width, precision, & printf_conv

   ; WORSPACE_44 low to high addresses
   ;
   ; offset  size  purpose
   ;
   ;   0       2   void *buffer_digits
   ;   2       2   return address following printf conversion
   ;   4       2   void *stack_param
   ;   6       2   address of next format char
   ;   8       3   prefix buffer space for printf conversion
   ;  11      33   buffer_digits[] (space for printf conversion)
   
   ret

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

match_con_printf:

   ; enter :   b = conversion specifier
   ;          hl = conversion table
   ;
   ; exit  :   b = conversion specifier
   ;
   ;         if matched
   ;
   ;              a = flags
   ;             hl = & printf converter
   ;             carry set
   ;
   ;         if unmatched
   ;
   ;             carry reset

   ld a,(hl)
   inc hl
   
   or a
   ret z
   
   cp b
   jr z, match_ret_printf

   inc hl
   inc hl
   inc hl
   
   jr match_con_printf

match_ret_printf:

   ld a,(hl)                   ; a = flags
   inc hl
   
   ld b,(hl)
   inc hl
   ld h,(hl)
   ld l,b                      ; hl = & printf converter
   
   scf
   ret

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

IF CLIB_OPT_PRINTF & $600

acon_tbl_printf:

IF CLIB_OPT_PRINTF & $200

defb 's', $80
EXTERN __stdio_printf_s
defw __stdio_printf_s

ENDIF

IF CLIB_OPT_PRINTF & $400

defb 'c', $80
EXTERN __stdio_printf_c
defw __stdio_printf_c

ENDIF

defb 0

ENDIF

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

IF CLIB_OPT_PRINTF & $1ff

rcon_tbl_printf:

IF CLIB_OPT_PRINTF & $01

defb 'd', $d0
EXTERN __stdio_printf_d
defw __stdio_printf_d

ENDIF

IF CLIB_OPT_PRINTF & $02

defb 'u', $90
EXTERN __stdio_printf_u
defw __stdio_printf_u

ENDIF

IF CLIB_OPT_PRINTF & $04

defb 'x', $00
EXTERN __stdio_printf_x
defw __stdio_printf_x

ENDIF

IF CLIB_OPT_PRINTF & $08

defb 'X', $80
EXTERN __stdio_printf_x
defw __stdio_printf_x

ENDIF

IF CLIB_OPT_PRINTF & $10

defb 'o', $a0
EXTERN __stdio_printf_o
defw __stdio_printf_o

ENDIF

IF CLIB_OPT_PRINTF & $20

defb 'n', $80
EXTERN __stdio_printf_n
defw __stdio_printf_n

ENDIF

IF CLIB_OPT_PRINTF & $40

defb 'i', $d0
EXTERN __stdio_printf_d
defw __stdio_printf_d

ENDIF

IF CLIB_OPT_PRINTF & $80

defb 'p', $80
EXTERN __stdio_printf_p
defw __stdio_printf_p

ENDIF

IF CLIB_OPT_PRINTF & $100

defb 'B', $90
EXTERN __stdio_printf_bb
defw __stdio_printf_bb

ENDIF

defb 0

ENDIF

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

IF CLIB_OPT_PRINTF & $3fc00000

fcon_tbl_printf:

IF CLIB_OPT_PRINTF & $10000000

defb 'g', $00
EXTERN __stdio_printf_g
defw __stdio_printf_g

ENDIF

IF CLIB_OPT_PRINTF & $20000000

defb 'G', $80
EXTERN __stdio_printf_g
defw __stdio_printf_g

ENDIF

IF CLIB_OPT_PRINTF & $4000000

defb 'f', $00
EXTERN __stdio_printf_f
defw __stdio_printf_f

ENDIF

IF CLIB_OPT_PRINTF & $8000000

defb 'F', $80
EXTERN __stdio_printf_f
defw __stdio_printf_f

ENDIF

IF CLIB_OPT_PRINTF & $1000000

defb 'e', $00
EXTERN __stdio_printf_e
defw __stdio_printf_e

ENDIF

IF CLIB_OPT_PRINTF & $2000000

defb 'E', $80
EXTERN __stdio_printf_e
defw __stdio_printf_e

ENDIF

IF CLIB_OPT_PRINTF & $400000

defb 'a', $00
EXTERN __stdio_printf_a
defw __stdio_printf_a

ENDIF

IF CLIB_OPT_PRINTF & $800000

defb 'A', $80
EXTERN __stdio_printf_a
defw __stdio_printf_a

ENDIF

defb 0

ENDIF

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

IF CLIB_OPT_PRINTF & $1ff000

lcon_tbl_printf:

IF CLIB_OPT_PRINTF & $1000

defb 'd', $d0
EXTERN __stdio_printf_ld
defw __stdio_printf_ld

ENDIF

IF CLIB_OPT_PRINTF & $2000

defb 'u', $90
EXTERN __stdio_printf_lu
defw __stdio_printf_lu

ENDIF

IF CLIB_OPT_PRINTF & $4000

defb 'x', $00
EXTERN __stdio_printf_lx
defw __stdio_printf_lx

ENDIF

IF CLIB_OPT_PRINTF & $8000

defb 'X', $80
EXTERN __stdio_printf_lx
defw __stdio_printf_lx

ENDIF

IF CLIB_OPT_PRINTF & $10000

defb 'o', $a0
EXTERN __stdio_printf_lo
defw __stdio_printf_lo

ENDIF

IF CLIB_OPT_PRINTF & $20000

defb 'n', $80
EXTERN __stdio_printf_ln
defw __stdio_printf_ln

ENDIF

IF CLIB_OPT_PRINTF & $40000

defb 'i', $d0
EXTERN __stdio_printf_ld
defw __stdio_printf_ld

ENDIF

IF CLIB_OPT_PRINTF & $80000

defb 'p', $80
EXTERN __stdio_printf_lp
defw __stdio_printf_lp

ENDIF

IF CLIB_OPT_PRINTF & $100000

defb 'B', $90
EXTERN __stdio_printf_lbb
defw __stdio_printf_lbb

ENDIF

defb 0

ENDIF

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

IF CLIB_OPT_PRINTF_2 && __SDCC

llcon_tbl_printf:

IF CLIB_OPT_PRINTF_2 & $01

defb 'd', $d0
EXTERN __stdio_printf_lld
defw __stdio_printf_lld

ENDIF

IF CLIB_OPT_PRINTF_2 & $02

defb 'u', $90
EXTERN __stdio_printf_llu
defw __stdio_printf_llu

ENDIF

IF CLIB_OPT_PRINTF_2 & $04

defb 'x', $00
EXTERN __stdio_printf_llx
defw __stdio_printf_llx

ENDIF

IF CLIB_OPT_PRINTF_2 & $08

defb 'X', $80
EXTERN __stdio_printf_llx
defw __stdio_printf_llx

ENDIF

IF CLIB_OPT_PRINTF_2 & $10

defb 'o', $a0
EXTERN __stdio_printf_llo
defw __stdio_printf_llo

ENDIF

IF CLIB_OPT_PRINTF_2 & $40

defb 'i', $d0
EXTERN __stdio_printf_lld
defw __stdio_printf_lld

ENDIF

defb 0

ENDIF

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

IF CLIB_OPT_PRINTF_2 && __SDCC

printf_return_8:

   ; printf converters that read eight bytes from stack_param return here
   ;
   ; carry set if error
   ; stack = WORKSPACE_36, char *format, void *stack_param

   pop bc

__return_join_8_printf:

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

   jr _return_join_6_printf

ENDIF

IF ((__SCCZ80 | __ASM) && (CLIB_OPT_PRINTF & $3fc00000)) || (CLIB_OPT_PRINTF_2 && __SDCC)

printf_return_6:

   ; printf converters that read six bytes from stack_param return here
   ;
   ; carry set if error
   ; stack = WORKSPACE_36, char *format, void *stack_param

   pop bc

_return_join_6_printf:

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

   jr _return_join_4_printf

ENDIF

printf_return_4:

   ; printf converters that read four bytes from stack_param return here
   ;
   ; carry set if error
   ; stack = WORKSPACE_36, char *format, void *stack_param

   pop bc

_return_join_4_printf:

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

   jr _return_join_2_printf

printf_return_2:

   ; printf converters that read two bytes from stack_param return here
   ;
   ; carry set if error
   ; stack = WORKSPACE_36, char *format, void *stack_param

   pop bc

_return_join_2_printf:

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
   
   jr c, error_printf_converter_printf
   
   ld hl,-8
   add hl,sp
   ld sp,hl
   
   push bc
   
   ; format_loop_printf expects this:
   ;
   ; de = char *format
   ; stack = WORKSPACE_44, stack_param

   jp format_loop_printf

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

error_format_precision_printf:

   ; de = address of next format char to examine
   ; stack = WORKSPACE_44, width, stack_param

   pop bc                      ; junk one item
   
   ; fall through

error_format_width_printf:

   ; de = address of next format char to examine
   ; stack = WORKSPACE_44, stack_param

   call error_erange_zc        ; set errno

   ; fall through

ENDIF

; ** AA BB ****************************************************
; all clib options have this code

error_stream_printf:

IF (CLIB_OPT_PRINTF != 0) || ((CLIB_OPT_PRINTF_2 != 0) && __SDCC)

   ; de = address of format char stopped on ('%' or '\0')
   ; stack = WORKSPACE_44, stack_param

   ld hl,46
 
__error_stream_printf:

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

IF (CLIB_OPT_PRINTF != 0) || ((CLIB_OPT_PRINTF_2 != 0) && __SDCC)

error_printf_converter_printf:

   ; de = address of next format char to examine
   ; stack = WORKSPACE_36

   ld hl,36
   jr __error_stream_printf

ENDIF
