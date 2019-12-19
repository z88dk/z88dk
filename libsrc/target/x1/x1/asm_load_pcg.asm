
        SECTION        code_clib

        PUBLIC        asm_load_charset
        PUBLIC        asm_load_pcg
        EXTERN        __x1_mode

        EXTERN        asm_z80_delay_tstate


; Load a series of characters - only works in mode0
; Entry:    hl = bitmap to load from
;            c = starting character
;            b = number of characters
asm_load_charset:
    push    bc
    push    bc
    ld      e,c
    ld      d,$20
    xor     a
    ld      bc,$33e0
loop:
    out     (c),e
    res     4,b
    out     (c),d
    set     4,b
    inc     bc
    dec     a
    jr      nz,loop
    pop     bc
    ld      c,0
    call    asm_load_pcg
    pop     bc
    inc     c
    djnz    asm_load_charset
    ret
    

; Load monochrome character into PCG data
; - we set the colour to white so the attributes define the colour
;
; Entry:  hl = data to load
;           c = pcg character to load
asm_load_pcg:
        ld      b,$15            ;PCG memory is $1500 -> $17ff
        push    hl
        call    load_plane
        pop     hl
        inc     b                ;red plane
        push    hl
        call    load_plane
        pop     hl
        inc     b                ;green plane
        call    load_plane
        ret


load_plane:
        di
        push    bc
        ld      e,8
        exx
        ld      bc, 0x1A01    ;wait for start of VBLANK
_vbl1:  in      a, (c) 
        jp      p, _vbl1   
_vbl2:  in      a, (c) 
        jp      m, _vbl2
        exx        
load_pcg_1:
        ld      a,(hl)               ; 7
        out     (c),a
 IF 0
        nop
        inc     hl
        inc     bc
        ld      a,$0e
loop_2:    
        dec     a
        jp      nz,loop_2
        dec     e
        jp      nz,load_pcg_1
ELSE
        ; We need to delay 250 - 22 - 10 - 4 - 4 - 7  -6 cycles
        exx                          ;4
        ld      hl,197               ;10
        call    asm_z80_delay_tstate ;taken care by callee
        exx                          ;4
        inc     hl                   ;6
        inc     bc
        dec     e                    ;4
        jp      nz,load_pcg_1        ;12
ENDIF
        pop     bc
        ei
        ret




