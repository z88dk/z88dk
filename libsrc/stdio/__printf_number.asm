    MODULE  __printf_number
    SECTION code_clib
    PUBLIC  __printf_number

    EXTERN  __printf_print_to_buf
    EXTERN  __printf_print_the_buffer
    EXTERN  l_int2long_s
    EXTERN  l_long_neg
    EXTERN  l_long_div_u
    EXTERN  l_div_u
    EXTERN  l_neg
    EXTERN  get_16bit_ap_parameter

    EXTERN  __printf_add_offset
    EXTERN  __printf_issccz80
    EXTERN  __printf_get_base
    EXTERN  __printf_check_long_flag
    EXTERN  __printf_context

    defc    handlelong = 1


; Print a number
; Entry: hl = fmt (character after format)
;        de = ap
;         c = 1 = signed, 0 = unsigned
__printf_number:
    push    hl          ;save fmt
IF __CPU_INTEL__ | __CPU_GBZ80__
    call    __printf_check_long_flag
ELSE
    bit     6,(ix-4)
ENDIF
    jr      z,printf_number16
IF __CPU_INTEL__ | __CPU_GBZ80__
    call    __printf_issccz80
ELSE
    bit     0,(ix+6)        ;sccz80 flag
ENDIF
    jr      nz,pickuplong_sccz80
    ; Picking up a long sdcc style
    ex      de,hl           ;hl=where tp pick up from
    ld      e,(hl)          ;LSW
    inc     hl
    ld      d,(hl)
    inc     hl
IF __CPU_GBZ80__
    ld      a,(hl+)
ELSE
    ld      a,(hl)
    inc     hl
ENDIF
    ld      b,(hl)
    inc     hl
    push    hl              ; save ap
    ld      h,b
    ld      l,a
    ex      de,hl           ;dehl=long, c: 1=signed, 0=unsigned
printlong:
    ld      a,c
    jp      miniprintn
pickuplong_sccz80:
    ex      de,hl
    ld      e,(hl)          ;MSW
    inc     hl
    ld      d,(hl)
    dec     hl
    dec     hl
    ld      b,(hl)          ;LSW
    dec     hl
IF __CPU_GBZ80__
    ld      a,(hl-)
ELSE
    ld      a,(hl)
    dec     hl
ENDIF
    dec     hl
    push    hl              ;Save ap for next time
    ld      h,b
    ld      l,a
    jr      printlong

printf_number16:
    call    get_16bit_ap_parameter  ;de = new ap, hl = number to print
    push    de              ; save ap
    ld      de,0            ;make it a long
    ld      a,c             ;signed?
    and     a
    call    nz,l_int2long_s ;extend it out
    jr      printlong


; Entry:        a = flag (0=unsigned, 1 = signed)
;               dehl =  number
miniprintn:
    ld      b,a
IF handlelong
    ld      a,d
ELSE
    ld      a,h
ENDIF
    rlca
    and     1
    and     b
    jr      z,noneg
IF handlelong
    call    l_long_neg
ELSE
    call    l_neg
ENDIF
    ld      a,'-'
printsign:
    call    __printf_print_to_buf
    jr      miniprintn_start_process


noneg:
IF __CPU_INTEL__ || __CPU_GBZ80__
    push    hl
  IF __CPU_GBZ80__
    ld      hl,__printf_context
    ld      a,(hl+)
    ld      h,(hl)
    ld      l,a
  ELSE
    ld      hl,(__printf_context)
  ENDIF
    dec     hl
    dec     hl
    dec     hl
    dec     hl
    ld      c,l
    ld      b,h
    pop     hl
    ld      a,(bc)
    and     8
    ld      a,' '
    jr      nz,printsign
    ld      a,(bc)
    and     2
    ld      a,'+'
    jr      nz,printsign
    ld      a,(bc)
    and     16
    jr      z,miniprintn_start_process
ELSE
    ld      a,' '
    bit     3,(ix-4)
    jr      nz,printsign
    ld      a,'+'
    bit     1,(ix-4)                ;do we force a +
    jr      nz,printsign
    bit     4,(ix-4)                ;# indicator
    jr      z,miniprintn_start_process
ENDIF
IF __CPU_INTEL__ | __CPU_GBZ80__
    push    hl
    call    __printf_get_base
    ld      a,l
    pop     hl
ELSE
    ld      a,(ix-9)                ;get base
ENDIF
    cp      10
    jr      z,miniprintn_start_process
    push    af
    ld      a,'0'
    call    __printf_print_to_buf
    pop     af
    cp      16
    jr      nz,miniprintn_start_process
    ld      a,'x'
IF __CPU_INTEL__ | __CPU_GBZ80__
    call    __printf_add_offset
 ELSE
    add     (ix-3)
ENDIF
    call    __printf_print_to_buf

miniprintn_start_process:
    xor     a
    push    af      ; set terminator

.divloop
IF handlelong
  IF __CPU_INTEL__ | __CPU_GBZ80__
    EXTERN  l_long_div_m
    push    de      ; number MSW
    push    hl      ; number LSW
    call    __printf_get_base
    ld      d,h
    ld      e,h
    call    l_long_div_m    ;returns modulus LSB in a
    cp      255
    push    af
  ELSE
    push    de      ; number MSW
    push    hl      ; number LSW
    ld      l,(ix-9)        ;base
    ld      h,0
    ld      d,h
    ld      e,h
    call    l_long_div_u
    exx
    ld      a,l
    cp      255     ; force flag to non-zero
    push    af      ; save reminder as a digit in stack
    exx
  ENDIF
ELSE
    ex      de,hl
  IF __CPU_INTEL__ | __CPU_GBZ80__
    call    __printf_get_base
  ELSE
    ld      l,(ix-9)        ;base
    ld      h,0
  ENDIF
    call    l_div_u         ;hl=de/hl de=de%hl
    ld      a,e
    cp      255  ; force flag to non-zero
    push    af      ; save reminder as a digit in stack
ENDIF

    ld      a,h
IF handlelong
    or      d
    or      e
ENDIF
    or      l               ; is integer part of last division  zero ?
    jr      nz,divloop      ; not still ?.. loop


    ; now recurse for the single digit
    ; pick all from stack until you get the terminator
    ;
.printloop
    pop     af
    jp      z,__printf_print_the_buffer
    add     '0'
    ; We only print hex at level 2
    cp      '9'+1
    jr      c,printloop1
    add     'a' - '9' -1
IF __CPU_INTEL__ | __CPU_GBZ80__
    call    __printf_add_offset
ELSE
    add     (ix-3)
ENDIF
printloop1:
    call    __printf_print_to_buf
    jr      printloop
