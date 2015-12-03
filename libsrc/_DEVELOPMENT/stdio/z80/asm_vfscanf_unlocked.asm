
; ===============================================================
; Jan 2014
; ===============================================================
; 
; int vfscanf_unlocked(FILE *stream, const char *format, void *arg)
;
; See C11 specification.
;
; ===============================================================

INCLUDE "clib_cfg.asm"

SECTION code_clib
SECTION code_stdio

PUBLIC asm_vfscanf_unlocked
PUBLIC asm0_vfscanf_unlocked, asm1_vfscanf_unlocked

EXTERN __stdio_verify_input, __stdio_scanf_sm_format, __stdio_recv_input_eatc
EXTERN __stdio_scanf_sm_format_pct, error_einval_zc

IF __CLIB_OPT_SCANF != 0

EXTERN __stdio_nextarg_bc, __stdio_length_modifier, error_erange_zc, l_atou

ENDIF

asm_vfscanf_unlocked:

   ; enter : ix = FILE *
   ;         de = char *format
   ;         bc = void *stack_param = arg
   ;
   ; exit  : ix = FILE *
   ;         de = char *format (next unexamined char)
   ;         hl = number of items assigned
   ;         de'= number of chars consumed from the stream
   ;         hl'= number of items assigned
   ;
   ;         success
   ;
   ;            carry reset
   ;
   ;         fail
   ;
   ;            hl will be -1 on eof and stream in error state
   ;            carry set, errno set as below
   ;
   ;            eacces = stream not open for reading
   ;            eacces = stream is in an error state
   ;            einval = unknown conversion specifier
   ;            einval = error during scanf conversion
   ;            erange = width out of range
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

asm1_vfscanf_unlocked:

   call __stdio_verify_input   ; check that input from stream is ok
   ret c                       ; if input is not possible

asm0_vfscanf_unlocked:

IF __CLIB_OPT_SCANF != 0

   ld hl,-40
   add hl,sp
   ld sp,hl                    ; create forty bytes of workspace
   
   push bc                     ; save stack_param

ENDIF

   exx
   ld de,0                     ; de = num chars read from stream = 0
   ld l,e
   ld h,d                      ; hl = num items assigned = 0
   exx

;******************************
; * FORMAT STRING LOOP ********

   ; de = char *format
   ; stack = WORKSPACE_40, stack_param

format_loop:
   
   ; MATCH STREAM CHARS UNTIL '%' OR '\0'
   
   ld hl,__stdio_scanf_sm_format  ; format string state machine

   exx

   ld bc,$ffff                    ; match as many chars as we can
   call __stdio_recv_input_eatc

   exx

percent_join:

   ld a,(de)
   jr c, possible_error
   
   ;  a = next char of format string
   ; de = char *format (address of next char)
   ; stack = WORKSPACE_40, stack_param
      
   cp '%'
   jr z, possible_conversion_0

   or a
   jr nz, mismatch_error
   
   ; reached end of format string

exit_success:

IF __CLIB_OPT_SCANF != 0

   ; stack = WORKSPACE_40, stack_param

   ld hl,42
   add hl,sp
   ld sp,hl                    ; repair stack

ENDIF

   exx
   push hl
   exx
   pop hl                      ; hl = num items assigned
   
   or a                        ; indicate success
   ret

mismatch_error:

   call error_einval_zc

exit_failure:

IF __CLIB_OPT_SCANF != 0

   ; stack = WORKSPACE_40, stack_param

   ld hl,42
   add hl,sp
   ld sp,hl                    ; repair stack

ENDIF

   exx
   push hl
   exx
   pop hl                      ; hl = num items assigned
   
   scf                         ; indicate failure
   ret

possible_error:

   ; stream error occurred
   ; if end of format string reached no one cares
   
   or a
   jr z, exit_success
   jr exit_failure

possible_conversion_0:

   ; format contains %, check for %%
   
   inc de
   ld a,(de)
   
   cp '%'
   jr nz, possible_conversion_1
   
   ; format contains %% so must consume % from stream

stream_consume_pct:

   ld b,1
   ld hl,__stdio_scanf_sm_format_pct  ; enter format state machine at percent

   exx

   ld bc,$ffff                 ; match as many chars as we can
   call __stdio_recv_input_eatc

   exx
   djnz percent_join           ; if % was seen on stream
   
   jr mismatch_error


IF __CLIB_OPT_SCANF != 0

error_format_width:

   ; stack = WORKSPACE_40, stack_param, void *p
   
   pop hl
   call error_erange_zc
   jr exit_failure

assignment_suppressed:

   inc de                      ; consume the '*'
   ld bc,0                     ; void *p = 0
   jr suppressed_rejoin

ENDIF


possible_conversion_1:

   ; only one % in format string
   
   or a
   jr z, stream_consume_pct    ; if format string ends in %


IF __CLIB_OPT_SCANF = 0

   ; completely disable % logic
   ; scanf can only match format chars to the input stream
   
   ; de = address char after % in char *format
   
   jr mismatch_error

ELSE

   ; regular % processing

;*******************************
; * PROCESS CONVERSION SPECIFIER

   ;  a = next char to examine
   ; de = char *format (address of next char to examine)
   ; stack = WORKSPACE_40, stack_param

   ; CHECK FOR ASSIGNMENT SUPPRESSION
   
   cp '*'
   jr z, assignment_suppressed

   ; read void *p from stack params
   
   pop hl
   call __stdio_nextarg_bc     ; bc = void *p
   
   push hl

suppressed_rejoin:

   push bc

   ; de = char *format (address of next char to examine)
   ; stack = WORKSPACE_40, stack_param, void *p

   ; READ OPTIONAL WIDTH
   
   call l_atou
   jr c, error_format_width    ; if overflow
   
   push hl                     ; save width (0 = default)
   
   ; READ OPTIONAL LENGTH MODIFIER
   
   call __stdio_length_modifier

   ; de = char *format (address of next char to examine)
   ;  c = length modifier id
   ; stack = WORKSPACE_40, stack_param, void *p, width

   ; SET UP REGISTERS FOR CONVERTERS

   ld hl,6
   add hl,sp                   ; hl = void *buffer
   
   ld a,c
   and $30                     ; long modifiers activated ?
   
   ld a,(de)                   ; a = conversion specifier
   inc de

   push de
   exx
   pop bc                      ; bc'= char *format (for %[)
   exx
   
   pop bc                      ; bc = width 
   ex de,hl                    ; de = void *buffer
   ex (sp),hl                  ; hl = void *p

   ;  a = conversion char
   ; bc = width (0 for default)
   ; de = void *buffer
   ; hl = void *p (0 for assignment suppression)
   ; bc'= char *format
   ; nz flag set if long modifier present
   ; stack = WORKSPACE_40, stack_param, char *format

   ; CONVERSION SPECIFIER

   ; identify conversion "B[cdiInopsux"
   ; long modifies "Bdinopux" not "[cIs"

   jr nz, spec_long

   ; no long modifier

IF __CLIB_OPT_SCANF & $200000

   cp '['
   jr z, _scanf_bkt            ; special treatment for '%['

ENDIF

   call spec_unmodified

   ; RETURN FROM CONVERSION

   ; stack = WORKSPACE_40, stack_param, char *format
   ; carry set on error

spec_return:

   pop de                      ; de = char *format
   jp nc, format_loop
   
   jr exit_failure

spec_unmodified:

IF __CLIB_OPT_SCANF & $01

   cp 'd'
   EXTERN __stdio_scanf_d
   jp z, __stdio_scanf_d

ENDIF

IF __CLIB_OPT_SCANF & $02
   
   cp 'u'
   EXTERN __stdio_scanf_u
   jp z, __stdio_scanf_u

ENDIF

IF __CLIB_OPT_SCANF & $40
   
   cp 'i'
   EXTERN __stdio_scanf_i
   jp z, __stdio_scanf_i

ENDIF

IF __CLIB_OPT_SCANF & $c0
   
   cp 'x'
   EXTERN __stdio_scanf_x
   jp z, __stdio_scanf_x

ENDIF

IF __CLIB_OPT_SCANF & $10
   
   cp 'o'
   EXTERN __stdio_scanf_o
   jp z, __stdio_scanf_o

ENDIF

IF __CLIB_OPT_SCANF & $80
   
   cp 'p'
   EXTERN __stdio_scanf_p
   jp z, __stdio_scanf_p

ENDIF

IF __CLIB_OPT_SCANF & $20
   
   cp 'n'
   EXTERN __stdio_scanf_n
   jp z, __stdio_scanf_n

ENDIF

IF __CLIB_OPT_SCANF & $100
   
   cp 'B'
   EXTERN __stdio_scanf_bb
   jp z, __stdio_scanf_bb

ENDIF

spec_constant:

IF __CLIB_OPT_SCANF & $200

   cp 's'
   EXTERN __stdio_scanf_s
   jp z, __stdio_scanf_s

ENDIF

IF __CLIB_OPT_SCANF & $400
   
   cp 'c'
   EXTERN __stdio_scanf_c
   jp z, __stdio_scanf_c

ENDIF

IF __CLIB_OPT_SCANF & $800
   
   cp 'I'
   EXTERN __stdio_scanf_ii
   jp z, __stdio_scanf_ii

ENDIF

   ; UNRECOGNIZED CONVERSION

   ; stack = WORKSPACE_40, stack_param, char *format, return

   pop hl                      ; junk return address
   pop de                      ; de = char *format
   
   dec de                      ; move back to unknown conversion char
   jp mismatch_error

spec_long:

   ; long modifier

IF __CLIB_OPT_SCANF & $200000

   cp '['
   jr z, _scanf_bkt            ; special treatment for '%['

ENDIF 

   call __spec_long
   jr spec_return

__spec_long:

IF __CLIB_OPT_SCANF & $1000

   cp 'd'
   EXTERN __stdio_scanf_ld
   jp z, __stdio_scanf_ld

ENDIF

IF __CLIB_OPT_SCANF & $2000
   
   cp 'u'
   EXTERN __stdio_scanf_lu
   jp z, __stdio_scanf_lu

ENDIF

IF __CLIB_OPT_SCANF & $40000
   
   cp 'i'
   EXTERN __stdio_scanf_li
   jp z, __stdio_scanf_li

ENDIF

IF __CLIB_OPT_SCANF & $c000
   
   cp 'x'
   EXTERN __stdio_scanf_lx
   jp z, __stdio_scanf_lx

ENDIF

IF __CLIB_OPT_SCANF & $10000
   
   cp 'o'
   EXTERN __stdio_scanf_lo
   jp z, __stdio_scanf_lo

ENDIF

IF __CLIB_OPT_SCANF & $80000
   
   cp 'p'
   EXTERN __stdio_scanf_lp
   jp z, __stdio_scanf_lp

ENDIF

IF __CLIB_OPT_SCANF & $20000
   
   cp 'n'
   EXTERN __stdio_scanf_ln
   jp z, __stdio_scanf_ln

ENDIF

IF __CLIB_OPT_SCANF & $100000
   
   cp 'B'
   EXTERN __stdio_scanf_lbb
   jp z, __stdio_scanf_lbb

ENDIF

   jr spec_constant

IF __CLIB_OPT_SCANF & $200000

_scanf_bkt:

   ; special treatment for %[
   ; bc' communicates the format pointer
   
   EXTERN __stdio_scanf_bkt
   call __stdio_scanf_bkt

   ; bc'= char *format   
   ; stack = WORKSPACE_40, stack_param, char *format (invalid)
   ; carry set on error
   
   pop bc                      ; junk invalid format
   exx
   push bc                     ; replace with valid one
   exx

   jr spec_return

ENDIF

ENDIF
