
    MODULE  __scanf_handle_f
    SECTION code_clib

IF ! __CPU_INTEL__
    PUBLIC  __scanf_handle_f

    EXTERN  __scanf_common_start
    EXTERN  scanf_exit
    EXTERN  __scanf_ungetchar
    EXTERN  __scanf_getchar
    EXTERN  scanf_loop

    EXTERN  __scanf_check_sign

    EXTERN  atof
    EXTERN  l_cmp
    EXTERN  asm_isdigit
    EXTERN  dstore
    EXTERN	CLIB_32BIT_FLOATS



; Floating point
; We read from the stream into a temporary buf on the stack and then run atof() on it
__scanf_handle_f:
    call    __scanf_common_start	
    jp      c,scanf_exit
    call    __scanf_ungetchar
    push    de          ;save destination
    ld      hl,2
    add     hl,sp
    ex      de,hl       ;de = our buffer for the number
    ld      c,0	       ;[000000E.]
IF __CPU_INTEL__
    call    __scanf_check_sign
ELSE
    bit     0,(ix-3)
ENDIF
    jr      z,handle_f_fmt_check_width
    ld      a,'-'
    ld      (de),a	
    inc     de
handle_f_fmt_check_width:
IF __CPU_INTEL__
    ld      b,0
    call    ___scanf_get_width
    ld      a,b
ELSE
    ld      a,(ix-4)	;width
ENDIF
    and     a
    jr      z,handle_f_fmt_check_width1
    cp      39		;maximum width
    jr      c,handle_f_fmt_setup_length
handle_f_fmt_check_width1:
    ld      a,39
handle_f_fmt_setup_length:	
    ld      b,a
handle_f_fmt_loop:
    call    __scanf_getchar
    jr      c,handle_f_fmt_finished_reading
    cp      '.'
    jr      nz,handle_f_fmt_check_exponent
    ; It was ., have we already seen one
    bit     0,c
    jr      nz,handle_f_fmt_error
    set     0,c
    jr      handle_f_fmt_store
handle_f_fmt_check_exponent:
    cp      'e'
    jr      z,handle_f_fmt_check_exponent1
    cp      'E'
    jr      nz,handle_f_fmt_check_digit
handle_f_fmt_check_exponent1:
    bit     1,c     ;have we seen one already?
    jr      nz,handle_f_fmt_error
    set     1,c
    jr      handle_f_fmt_store
handle_f_fmt_check_digit:
    call    asm_isdigit
    jr      nc,handle_f_fmt_store
    call    __scanf_ungetchar
    jr      handle_f_fmt_finished_reading
handle_f_fmt_store:
    ld      (de),a
    inc     de
    djnz    handle_f_fmt_loop
handle_f_fmt_finished_reading:
    xor     a
    ld      (de),a
    ld      hl,2
    add     hl,sp
    call    l_cmp
    jr      z,handle_f_fmt_error
    ; TODO: Check there's something there
    ld      hl,2    ;we have the destination on the stack
    add     hl,sp
IF !__CPU_INTEL__
    push    ix      ;save our framepointer - fp library will disturb it
ENDIF
    push    hl
    call    atof
    pop     bc
IF !__CPU_INTEL__
    pop     ix      ;get our framepointer back
ENDIF
    ld      a,CLIB_32BIT_FLOATS
    and     a
    jr      z,store_48bit_float
    push    hl      ;LSW
    pop     bc      ;LSW
    pop     hl      ;destination
    ld      (hl),c  ;Store LSW
    inc     hl
    ld      (hl),b
    inc     hl
    ld      (hl),e  ;Store MSW
    inc     hl
    ld      (hl),d
    jr      store_rejoin
store_48bit_float:
    pop     hl      ;destination
    call    dstore  ;and put it there
store_rejoin:
IF __CPU_INTEL__
    call    __scanf_increment_conversions
ELSE
    inc     (ix-1)  ;increase number of conversions
ENDIF
    jp      scanf_loop
handle_f_fmt_error:
    call    __scanf_ungetchar
    pop	    de  ;discard destinatino
    jp      scanf_exit

ENDIF