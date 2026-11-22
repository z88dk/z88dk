
    MODULE  asm_z88_copy_zxscreen
    SECTION code_graphics

    INCLUDE "interrpt.def"

    PUBLIC  asm_z88_copy_zxscreen

    EXTERN  __z88_gfxbank
    EXTERN  base_graphics

    EXTERN  SCREEN_BASE
    EXTERN  CLIB_ZX_SCREEN_HEIGHT

;
; Entry: d = y position (we start from - 3)
;        e = flags (0 = inverse, 1 = squished)
;           
.asm_z88_copy_zxscreen
    ld      hl,$4D1
    ld      a,(hl)
    push    af
    ld      a,(__z88_gfxbank)
    ld      (hl),a
    ld      bc,(base_graphics)
    push    bc
    out     ($D1),a
    ld      b,d     ;varbase
    ld      a,e     ;myflags
    ld      de,ozfullcpy
    bit     1,a 
    jr      z,ozskhalf
    ld      de,ozhalfcpy
.ozskhalf
    exx
    ld      c,0
    bit     0,a
    jr      z,ozskinv
    ld      c,255
.ozskinv
    pop     hl      ;screen address
    exx
    call    oz_di
    push    af
    call    ozcallch
    pop     af
    call    oz_ei
    pop     af
    ld      ($4D1),a
    out     ($D1),a
    ret

.ozcallch
    push    de
    ret

.ozfullcpy
    ld      a,b         ;y position to centre on
    ; rrca
    ; rrca
    ; rrca
    and     31
    cp      +(CLIB_ZX_SCREEN_HEIGHT - 4)
    jr      c,scrcpya
    ld      a,+(CLIB_ZX_SCREEN_HEIGHT - 5)
.scrcpya  
    sub     3
    jr      nc,scrcpy0
    xor     a
.scrcpy0
    ld      b,a
    ld      c,8
.scrcpy1  
    push    bc
    ; Calculate address of row 'b' in ZX screen memory
    ld      a,b
    and     248
    add     a,+(SCREEN_BASE/256)
    ld      d,a
    ld      a,b
    and     7
    rrca
    rrca
    rrca
    ld      e,a

    ; Add copy each row - OZ screen is character based
    ld      c,32
.scrcpy2
    ld      b,8
    push    de
.scrcpy3  
    ld      a,(de)
    exx
    xor     c
    ld      (hl),a
    inc     hl
    exx
    inc     d
    djnz    scrcpy3
    pop     de
    inc     e
    dec     c
    jp      nz,scrcpy2
    pop     bc
    inc     b
.scrcpy36 
    ex      af,af
    dec     c
    jp      nz,scrcpy1
    ret


;Screen copy for half size (this only does top 2/3 ATM)

.ozhalfcpy
    ld      de,SCREEN_BASE
.ozhalfcpy1
    ld      b,4
.ozhalfcpy2
    ld      a,(de)
    exx
    xor     c
    ld      (hl),a
    inc     hl
    exx
    inc     d
    inc     d
    djnz    ozhalfcpy2
    ld      a,d
    sub     8
    ld      d,a
    ld      a,e
    add     a,32
    ld      e,a
    ld      b,4
.ozhalfcpy3
    ld      a,(de)
    exx
    xor     c
    ld      (hl),a
    inc     hl
    exx
    inc     d
    inc     d
    djnz    ozhalfcpy3
    ld      a,d
    sub     8
    ld      d,a
    ld      a,e
    sub     31
    ld      e,a
    and     31
    jp      nz,ozhalfcpy1
    ld      a,e
    add     a,32
    ld      e,a
    and     a
    jp      nz,ozhalfcpy1
    ld      a,d
    add     a,8
    ld      d,a
    cp      32+16
    jp      c,ozhalfcpy1
    ret

