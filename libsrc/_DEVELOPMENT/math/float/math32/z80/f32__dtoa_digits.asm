
SECTION code_clib
SECTION code_fp_math32

PUBLIC m32__dtoa_digits

.m32__dtoa_digits

    ; generate decimal digits into buffer, from up to 8 packed BCD digits
    ;
    ; enter : EXX = mantissa bits, most sig four bits contain a BCD digit
    ;           B = number of digits to generate
    ;           C = remaining significant digits
    ;          HL = buffer * (address of next char to write)
    ;
    ; exit  :   B = remaining number of BCD digits to generate
    ;           C = remaining number of significant digits
    ;          HL = buffer * (address of next char to write)
    ;
    ;          carry reset if exhausted significant digits and exit early (C=0, B!=0)
    ;
    ; uses  : af, bc, hl, bc', de', hl'

    exx
    ld a,d
    rra
    rra
    rra
    rra
    and 0fh
    add a,'0'                   ; a = decimal digit

    exx
    ld (hl),a                   ; write decimal digit
    inc hl

    dec c
    ret Z                       ; if no more significant digits

    exx
    add hl,hl                   ; shift one BCD digit
    rl e
    rl d
    add hl,hl
    rl e
    rl d
    add hl,hl
    rl e
    rl d
    add hl,hl
    rl e
    rl d

    exx  
    djnz m32__dtoa_digits

    scf                         ; indicate all digits output
    ret

