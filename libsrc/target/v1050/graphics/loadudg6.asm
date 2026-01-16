;
;   Visual 1050 pseudo graphics routines
;
;   Load a 2x3 pseudo-graphics at HL position,
;   starting from character C

;       Written by Stefano Bodrato 2025
;
;
;   $Id: loadudg6.asm $
;

    SECTION code_clib
    PUBLIC  loadudg6
    
    EXTERN  v1050_sendchar
    EXTERN  __v1050_byte


loadudg6:
    ld c,0             ; We load the characters in G2
    ld b,64

loadudg6_loop:

    ld a,192
    add c
    ld d,a

    push    bc
    ld e,0
    call    setbyte      ; 12 rows in total, split into 3 chunks
    call    setbyte
    call    setbyte
    pop     bc

    inc     c
    djnz    loadudg6_loop

    ret


; Deal with the 2 rightmost bits in a byte
setbyte:
    call    setbyte2
    call    load_byte
    call    load_byte
    call    load_byte
    call    load_byte
    rr      c                  ; move on on the next bits
    rr      c
    ret

setbyte2:
    xor     a
    bit     0, c
    jr      z, noright
    ld      a, $0f
noright:
    bit     1, c
    ret     z
    add     $f0
    ret



    ; Load a single byte in the character bitmap
    ; E = row# in chr$ (0..11)
    ; A = byte value

load_byte:

    ; ESC > c ; row ; byte_value F

    push    hl
    push    af

    ld      l, 27
    call    v1050_sendchar
    ld      l, '>'
    call    v1050_sendchar
    ; chr% code
    ld      l, '='
    call    v1050_sendchar
    ld      l, d
    call    v1050_sendchar
    ld      l, 0
    call    v1050_sendchar

    ld      l, ';'
    call    v1050_sendchar

    ld      a, e
    call    __v1050_byte
    inc     e                      ; increment character row count
    ld      l, ';'
    call    v1050_sendchar

    pop     af
    push    af
    call    __v1050_byte

    ld      l, 'F'
    call    v1050_sendchar

    pop     af  ; keep the current byte
    pop     hl
    ret


