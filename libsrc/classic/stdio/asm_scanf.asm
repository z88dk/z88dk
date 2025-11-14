
    MODULE  asm_scanf
    SECTION code_clib
    PUBLIC  asm_scanf
    PUBLIC  __scanf_getchar
    PUBLIC  __scanf_ungetchar
    PUBLIC  __scanf_noop
    PUBLIC  scanf_exit
    PUBLIC  scanf_loop
    PUBLIC  __scanf_nextarg

    EXTERN  __scanf_parse_number
    EXTERN  __scanf_common_start
    EXTERN  __scanf_get_number
    EXTERN  __scanf_format_table
    EXTERN  __scanf_consume_whitespace

    EXTERN  __scanf_context
    EXTERN  __scanf_set_suppressed
    EXTERN  __scanf_reset_flags
    EXTERN  __scanf_set_width
    EXTERN  __scanf_set_longflag
    EXTERN  __scanf_get_fp
    EXTERN  __scanf_increment_bytesread
    EXTERN  __scanf_decrement_bytesread

    EXTERN  asm_isspace
    EXTERN  asm_isdigit
    EXTERN  asm_isxdigit
    EXTERN  asm_isodigit
    EXTERN  asm_isbdigit
    EXTERN  asm_toupper
    EXTERN  l_long_mult
    EXTERN  l_long_neg
    EXTERN  asm_atoi
    EXTERN  atof
    EXTERN  fa
    EXTERN  l_cmp
    EXTERN  fgetc
    EXTERN  ungetc

; int vfscanf1(FILE *fp, int sccz80, unsigned char *fmt,void *ap)
asm_scanf:
IF __CPU_INTEL__
    ld      hl,0
    add     hl,sp
    ld      (__scanf_context),hl
ELSE
    ld      ix,0
    add     ix,sp        ; Now the frame pointer
                ; ix+2, ix+3 = arg pointer
ENDIF
IF __CPU_RABBIT__
    add     sp,-50
ELSE
    ld      hl,-50        ; make some space on the stack
    add     hl,sp
    ld      sp,hl
ENDIF

    ; -1, -2 = conversions done
        ; -3 = flags [^00a*WL0]
    ; -4 = width
    ; -5, -6 = bytes read from stream
    ; -50->-10 = fp number buffer
    xor     a
IF __CPU_INTEL__
    ld      hl,(__scanf_context)
    dec     hl
    ld      (hl),a      ;-1
    dec     hl
    ld      (hl),a      ;-2
    dec     hl
    dec     hl
    ld      (hl),a      ;-4
    dec     hl
    ld      (hl),a      ;-5
    dec     hl
    ld      (hl),a      ;-6
ELSE
    ld      (ix-1),a
    ld      (ix-2),a
    ld      (ix-4),a
    ld      (ix-5),a
    ld      (ix-6),a
ENDIF

IF __CPU_INTEL__
    ld      hl,(__scanf_context)
    inc     hl
    inc     hl
    inc     hl
    inc     hl
    ld      a,(hl)
    inc     hl
    ld      h,(hl)
    ld      l,a
ELSE
    ld      hl,(ix+4)       ;format pointer
ENDIF

scanf_loop:
__scanf_noop:            ;noop destination
IF __CPU_INTEL__
    call    __scanf_reset_flags
ELSE
    ld      (ix-3),0    ;reset flags for each loop
    ld      (ix-4),0    ;reset width
ENDIF
    ld      a,(hl)
    and     a
    jr      z,scanf_exit

    inc     hl
    cp      '%'
    jr      z,is_percent
    ld      c,a        ;save character
    call    asm_isspace
    jr      nz, scanf_ordinary_char
    call    __scanf_consume_whitespace
    jr      scanf_loop

; It's an ordinary char
scanf_ordinary_char:
    call    __scanf_getchar
    jr      c,scanf_exit
    cp      c
    jr      z,scanf_loop
    call    __scanf_ungetchar
scanf_exit:
   ; ISO C has us exit with # conversions done
   ; or -1 if no chars were read from the input stream
IF __CPU_INTEL__
    ld      hl,(__scanf_context)
    ld      de,-5
    add     hl,de
    ld      a,(hl)
    dec     hl	;-6
    or      (hl)
    ld      de,-1
    jr      z,scanf_exit2
    ld      de,5
    add     hl,de       ;hl = ix-1
    ld      e,(hl)
    ld      d,0
ELSE
    ld      a,(ix-6)
    or      (ix-5)
    ld      de,-1
    jr      z,scanf_exit2
    ld      e,(ix-1)
    ld      d,0
ENDIF
scanf_exit2:
IF __CPU_RABBIT__
    add     sp,50
ELSE
    ld      hl,50
    add     hl,sp
    ld      sp,hl
ENDIF
    ex      de,hl
    ret

    
is_percent:
    ; % {flags} [*] [width] [l] "[diouxXeEfFscpPbn"
flagloop:
    ld      a,(hl)
;    cp    'a'        ;network byte order
;    jr    nz,nextflag0
;    set    4,(ix-3)
;    inc    hl
;    jr    flagloop
nextflag0:
    cp      '*'
    jr      nz,width
IF __CPU_INTEL__
    call    __scanf_set_suppressed
ELSE
    set     3,(ix-3)
ENDIF
    inc     hl
    jr      flagloop
width:
    ld      a,(hl)
    call    asm_isdigit
    jr      c,formatchar
    call    asm_atoi        ;exits hl=number, de = non numeric in fmt
    ex      de,hl
IF __CPU_INTEL__
    call    __scanf_set_width
ELSE
    set     2,(ix-3)    ;set width flag
    ld      (ix-4),e
ENDIF
formatchar:
    ; Consider those that aren't affected by a long modifier first
    ld      a,(hl)
    inc     hl
    ld      c,a
    cp      '%'            ; %% should match a single %
    jr      z,scanf_ordinary_char
    cp      'h'            ; short specifier
    jr      z,get_next_char
    cp      'l'
    jr      nz, not_long_specifier
IF __CPU_INTEL__
    call    __scanf_set_longflag
ELSE
    set     1,(ix-3)
ENDIF
get_next_char:
    ld      c,(hl)
    inc     hl
not_long_specifier:
    ld      de,__scanf_format_table
    ex      de,hl
scanf_format_loop:
    ld      a,(hl)
    and     a
    jr      z,format_nomatch
    cp      c
    jr      z,format_matched
    inc     hl
    inc     hl
    inc     hl
    jr      scanf_format_loop
format_matched:
    inc     hl
    ld      c,(hl)        ;bc = address of formatter
    inc     hl
    ld      b,(hl)
    ex      de,hl        ;hl = format string
    push    bc
    ret
format_nomatch:
    ex      de,hl        ;hl = format string
    jp      scanf_loop

    






__scanf_nextarg:
    push    hl    ;hl=fmt, save it
IF __CPU_INTEL__
    ld      hl,(__scanf_context)
    inc     hl
    inc     hl
    ld      e,(hl)
    inc     hl
    ld      d,(hl)
    ex      de,hl
ELSE
    ld      hl,(ix+2)
ENDIF
    ld      e,(hl)
    inc     hl
    ld      d,(hl)        ;de = buffer, hl=ap+1
IF __CPU_INTEL__
    push    hl
    push    de
    ld      hl,(__scanf_context)
    ld      de,6
    add     hl,de
    ld      a,(hl)
    and     1
    pop     de
    pop     hl
ELSE
    bit     0,(ix+6)    ;sccz80 flag
ENDIF
    jr      nz,__scanf_nextarg_decrement
    inc     hl
__scanf_nextarg_exit:
IF __CPU_INTEL__
    push    de
    ex      de,hl
    ld      hl,(__scanf_context)
    inc     hl
    inc     hl
    ld      (hl),e
    inc     hl
    ld      (hl),d
    ex      de,hl
    pop     de
ELSE
    ld      (ix+2),hl
ENDIF
    pop     hl    ;restore fmt
    ret
__scanf_nextarg_decrement:
    dec     hl
    dec     hl
    dec     hl
    jr      __scanf_nextarg_exit

; Exit: a = character    
; NB: the supplied function must save ix
__scanf_getchar:
    push    bc        ;save callers
    push    de        ;save dest
    push    hl        ;fmt
IF __CPU_INTEL__
    call    __scanf_get_fp
ELSE
    ld      hl,(ix+8)	;fp
ENDIF
    push    hl
    call    fgetc
    pop     bc
__scanf_getchar_return:
    inc     hl
    ld      a,h    
    or      l
    scf
    jr      z,__scanf_getchar_return1
    dec     hl
    ;inc    a    ; if eof then 0
    ld      a,l    ; set the return value
    and     a
    scf
    jr      z,__scanf_getchar_return1
IF __CPU_INTEL__
    call    __scanf_increment_bytesread
    and     a
ELSE
    and     a    ;reset carry
    inc     (ix-6)
    jr      nz,__scanf_getchar_return1
    inc     (ix-5)
ENDIF
__scanf_getchar_return1:
    pop     hl
    pop     de
    pop     bc
    ret

; a=char to unget
; NB: the supplied function must save ix
__scanf_ungetchar:
    push    bc
    push    de
    push    hl        ;fmt
IF __CPU_INTEL__
    call    __scanf_decrement_bytesread
ELSE
    ld      de,(ix-6)
    dec     de
    ld      (ix-6),de
ENDIF
__scanf_ungetchar1:
    ld      l,a        ;character to unget
    ld      h,0
    push    hl
IF __CPU_INTEL__
    call    __scanf_get_fp
    push    hl
ELSE
    ld      bc,(ix+8)    ;fp
    push    bc
ENDIF
    call    ungetc
    pop     bc
    pop     bc
    jr      __scanf_getchar_return1
