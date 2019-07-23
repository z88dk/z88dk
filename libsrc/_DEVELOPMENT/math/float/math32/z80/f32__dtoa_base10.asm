
SECTION code_clib
SECTION code_fp_math32

PUBLIC m32__dtoa_base10

m32__dtoa_base10:

    ; convert double from standard form "a * 2^n"
    ; to a form multiplied by power of 10 "b * 10^e"
    ; where 1 <= b < 10 with b in double format
    ;
    ; rewritten from math48 code and code by Alwin Henseler
    ;
    ; enter : DEHL'= double x, x positive
    ;
    ; exit  : DEHL'= b where 1 <= b < 10 all mantissa bits only
    ;          C   = max number of significant decimal digits (7)
    ;          D   = base 10 exponent e
    ;
    ; uses  : af, bc, de, hl, iy, bc', de', hl'

    ; x = a * 2^n = b * 10^e
    ; e = n * log(2) = n * 0.301.. = n * 0.01001101...(base 2) = INT((n*77 + 5)/256)

    exx
    sla l                       ; move mantissa without leading 1
    rl h
    rl e
    rl d
    ld a,d                      ; get exponent in a

    exx
    ;  A = n (binary exponent)
    ;  EHL'= x mantissa bits without leading 1.
    sub $7e                     ; subtract excess (bias - 1)
    ld l,a
    sbc a,a
    ld h,a                      ; hl = signed n

    push hl                     ; save n
    add hl,hl
    add hl,hl
    push hl                     ; save 4*n
    add hl,hl
    ld c,l
    ld b,h                      ; bc = 8*n
    add hl,hl
    add hl,hl
    add hl,hl                   ; hl = 64*n
    add hl,bc
    pop bc
    add hl,bc
    pop bc
    add hl,bc                  ; hl = 77*n
    ld bc,5
    add hl,bc                  ; rounding fudge factor

    ld a,h                     ; a = INT((77*n+5)/256)
    cp -39
    jr nz, no_correction
    inc a

.no_correction
    push af                     ; save exponent e

    exx
    call bin2bcd
    pop bc                      ; exponent in bc
    ld c,7                      ; maximum sigificant digits

.shiftdec
    ld a,d                      ; check for a leading significant digit
    and 0f0h
    jr NZ,finish
    
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

    dec b                       ; reduce decimal exponent
    dec c                       ; reduce significant digits
    jr shiftdec

.finish
    push bc
    
    exx                         ; move mantissa to DEHL'
    pop bc                      ; recover decimal exponent and significant digits
    ld d,b
    ret


; Routine for converting a 24-bit binary number to decimal
; In: E:HL = 24-bit binary number (0-16777215)
; Out: DE:HL = 8 digit decimal form (packed BCD)
; Changes: AF, BC, DE, HL, & IY
;
; by Alwin Henseler

.bin2bcd
    ld c,e
    push hl
    pop iy                      ; input value in C:IY
    ld hl,1
    ld d,h
    ld e,h                      ; start value corresponding with 1st 1-bit
    ld b,24                     ; bitnr. being processed + 1

.find1
    add iy,iy
    rl c                        ; shift bit 23-0 from C:IY into carry
    jr C,nextbit
    djnz find1                  ; find highest 1-bit

; all bits 0:
    res 0,l                     ; least significant bit not 1
    ret

.dblloop
    ld a,l
    add a,a
    daa
    ld l,a
    ld a,h
    adc a,a
    daa
    ld h,a
    ld a,e
    adc a,a
    daa
    ld e,a
    ld a,d
    adc a,a
    daa
    ld d,a                      ; double the value found so far
    add iy,iy
    rl c                        ; shift next bit from C:IY into carry
    jr NC,nextbit               ; bit = 0 -> don't add 1 to the number
    SET 0,L                     ; bit = 1 -> add 1 to the number
.nextbit
    djnz dblloop
    ret

