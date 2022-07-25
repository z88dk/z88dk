
SECTION code_clib
SECTION code_fp_math32

PUBLIC m32__dtoa_digits

.m32__dtoa_digits

    ; generate decimal digits into buffer
    ;
    ; enter : EXX = mantissa bits, most sig four bits contain decimal digit
    ;           B = number of digits to generate
    ;           C = remaining significant digits
    ;          HL = buffer * (address of next char to write)
    ;
    ; exit  :   B = remaining number of digits to generate
    ;           C = remaining number of significant digits
    ;          HL = buffer * (address of next char to write)
    ;
    ;          carry reset if exhausted significant digits and exit early (C=0, B!=0)
    ;
    ; uses  : af, bc, hl, bc', de', hl'

    ld a,c
    or a
    ret Z                       ; if no more significant digits

    exx
    ld a,d
    rra
    rra
    rra
    rra
    and $0f
    add a,'0'                   ; a = decimal digit

    exx
    ld (hl),a                   ; write decimal digit
    inc hl

    exx
    ld a,d
    and $0f
    ld d,a
                                ; 10*a = 2*(4*a + a)     
    push de                     ; DEHL *= 10
    push hl
    sla l
    rl h
    rl e
    rl d
    sla l
    rl h
    rl e
    rl d
    ex de,hl
    ex (sp),hl
    add hl,de
    pop de
    ex (sp),hl
    adc hl,de
    ex de,hl
    pop hl
    sla l
    rl h
    rl e
    rl d

    exx
    dec c                       ; significant digits --
    djnz m32__dtoa_digits

    scf                         ; indicate all digits output
    ret

