
    MODULE  tim011_pixladdr
    SECTION   code_clib

    PUBLIC  w_pixeladdress
    EXTERN  __gfx_fatpix
    EXTERN  __tim011_scroll


; Entry  hl = x
;        de = y
; Exit: hl = de = address
;        a = pixel number
; Uses: a, bc, de, hl
.w_pixeladdress
    ld      a,(__gfx_fatpix)
    and     a
    jr      z,not_fatpix    ;We could just jump into the rotation properly
    add     hl,hl
not_fatpix:
    ; Reduce x down to the byte number
    ld      b,l             ;Save lower of number
    srl     h               ;Max 256
    rr      l
    sra     l               ;Max 128
    ld      h,l
    set     7,h
    ; l = byte offset in row
    ld      a,(__tim011_scroll)
    add     e
    ld      l,a
    ; Now calculate the bit position
    ld      a,b 
    and     3
    xor     3
    ret
