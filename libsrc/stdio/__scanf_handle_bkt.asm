
    MODULE  __scanf_handle_bkt
    SECTION code_clib
    PUBLIC  __scanf_handle_bkt

    EXTERN  __scanf_common_start
    EXTERN  __scanf_nextarg
    EXTERN  scanf_exit
    EXTERN  __scanf_ungetchar
    EXTERN  __scanf_getchar
    EXTERN  scanf_loop
    EXTERN  __scanf_set_caretflag
    EXTERN  __scanf_get_width
    EXTERN  __scanf_get_flags
    EXTERN  __scanf_increment_conversions
    EXTERN  __scanf_check_suppressed


__scanf_handle_bkt:
    ex      de,hl           ;de = format string
    ; Create an empty bitset array
    ld      hl,0
    ld      a,16
.createcharsetlp
    push    hl
    dec     a
    jp      nz, createcharsetlp

    ld      a,(de)
    cp      '^'                      ; is '^' a leading char?
    jr      nz, leading

IF __CPU_INTEL__ || __CPU_GBZ80__
    call    __scanf_set_caretflag
ELSE
    set     7,(ix-3)                     ; set carat flag
ENDIF
    inc     de
    ld      a,(de)                   ; on to next char in format string
.leading


    cp      ']'                      ; is ']' a leading char?
    jr      nz, fillcharset0

    call    addcharA
    inc     de                      ; on to next char in format string

    ; '-' will be caught in regular loop

.fillcharset0

    ; here we are starting from a blank slate... have no pending left char
    ;    de = format string
    ; stack = & parameter list, ret, char set bitmap (32 bytes), width + flags
    ld      a,(de)
    or      a
    jr      z, endcharset0           ; premature end of format string should be an error but taken as ']'

    inc     de
    cp      ']'                      ; reached end of char set?
    jr      z, endcharset0

    ld      b,a                      ; got our left char

.fillcharset1
    ; we've seen a left char
    ;     b = left char
    ;     c = flags [^00a*WL0]
    ;    de = format string
    ; stack = & parameter list, ret, char set bitmap (32 bytes), width + flags

    ld      a,(de)                   ; premature end of format string should be an error but taken as ']'
    or      a
    jr      z, endcharset1

    inc     de
    cp      ']'                      ; end of char set?
    jr      z, endcharset1

    cp      '-'                      ; range char?
    jr      z, fillcharset2

    ; seen a left char in 'b' and have a following char in 'a'
    ; add left char to character set and make char in 'a' the new left char

    ld      l,b
    ld      b,a                      ; latest char becomes left char
    ld      a,l
    call    addcharA
    jr      fillcharset1

.fillcharset2

    ; we've seen a left char and a range char '-'
    ;     b = left char in range
    ;     c = flags [^00a*WL0]
    ;    de = format string
    ; stack = & parameter list, ret, char set bitmap (32 bytes), width + flags

    ld      a,(de)                   ; premature end of format string should be an error but taken as ']'
    or      a
    jr      z, endcharset2

    inc     de
    cp      ']'                      ; end of char set?
    jr      z, endcharset2
    cp      b                       ; make sure right char (A) > left char (B)
    jr      nc, rangelp

    ld      l,a                     ; if not swap left and right to get increasing order in range
    ld      a,b
    ld      b,l

.rangelp

    call    addcharA
    dec     a                      ; move to next char in range
    cp      b                       ; check if end of range reached
    jr      nc, rangelp
    jr      fillcharset0

.endcharset2
    ; we've seen a left char and a range char '-'
    ;     b = left char in range
    ;     c = flags [^00a*WL0]
    ;    de = format string
    ; stack = & parameter list, ret, char set bitmap (32 bytes), width + flags

    ld      a,'-'                    ; add the minus to the charset
    call    addcharA

.endcharset1

    ; we've seen a left char
    ;     b = left char
    ;     c = flags [^00a*WL0]
    ;    de = format string
    ; stack = & parameter list, ret, char set bitmap (32 bytes), width + flags

    ld      a,b                     ; add the left char to the charset
    call    addcharA

.endcharset0

    ; ***********************************************************************
    ; PART 2
    ; Match characters from stream to charset and write to destination buffer
    ; ***********************************************************************
IF __CPU_INTEL__ || __CPU_GBZ80__
    call    __scanf_get_width
    call    __scanf_get_flags
ELSE
    ld      c,(ix-3)
    ld      b,(ix-4)
ENDIF
    push    de          ;Save format - we need to return it in hl
    ;     b = width
    ;     c = flags [^00a*WL0]

IF __CPU_INTEL__
    ld      a,c
    and     8
ELSE
    bit     3,c                    ; suppress assignment?
ENDIF
    call    z,__scanf_nextarg      ; de=destination
    push    de                     ; save char *s

.loop
    call    __scanf_getchar
    jr      c, done

    call    computebitsetaddr

    ld      a,c
    rla
    sbc     a,a
    xor     (hl)                    ; if ^ invert charset bitmap
    and     d                       ; if specific charset bit set we have a match
    jr      z, finished

    ; char is in bitset so add to string
IF __CPU_INTEL__
    call    __scanf_check_suppressed
ELSE
    bit     3,c
ENDIF
    jr      nz, suppress1

    ld      a,e                      ; write char into char *s
    pop     de                      ; de = char *s
    ld      (de),a
    inc     de
    push    de                     ; save char *s

.suppress1

IF __CPU_INTEL__
    ld      a,c
    and     4
ELSE
    bit     2,c                     ; without width specifier just loop back
ENDIF
    jr      z, loop
    djnz    loop

.done

    pop     de                      ; de = char *s
    pop     hl                      ; hl = fmt

IF __CPU_INTEL__
    call    __scanf_check_suppressed
ELSE
    bit     3,c
ENDIF
    jr      nz, adjuststack

    xor     a
    ld      (de),a                  ; write terminating \0 to string
IF __CPU_INTEL__
    call    __scanf_increment_conversions
ELSE
    inc     (ix-1)                  ;number of conversions
ENDIF

.adjuststack
    ex      de,hl
    ld      hl,32
    add     hl,sp
    ld      sp,hl
    ex      de,hl
    jp      scanf_loop


.finished

    ld      a,e
    call    __scanf_ungetchar
    jr      done


computebitsetaddr:

    ; enter :  a = char
    ;         stack = ..., char set bitmap (32 bytes), fmt, argptr, ret
    ; exit  :  d = mask
    ;          e = char
    ;         hl = bitset addr
    ; uses  : af, de, hl

    ld      e,a                      ; e = char

    rra
    rra
    rra                         ; a = char / 8

    and     $1f
    add     a,6
    ld      l,a
    ld      h,0
    add     hl,sp                   ; hl = corresponding & in char set bitmap

    ld      a,e
    and     $07
    ld      d,1
    ret     z

.bitrot
IF __CPU_INTEL__
    push    af
    ld      a,d
    rla
    ld      d,a
    pop     af
ELSE
    rl      d
ENDIF
    dec     a
    jr      nz, bitrot
    ret

.addcharA

    push    de
    call    computebitsetaddr
    ld      a,(hl)
    or      d
    ld      (hl),a
    ld      a,e
    pop     de
    ret
