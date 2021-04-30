;
;    Fast background restore
;
;    Generic version (just a bit slow)
;
;    $Id: w_bkrestore.asm $
;

IF !__CPU_INTEL__
    SECTION   smc_clib
    
    PUBLIC    bkrestore
    PUBLIC    _bkrestore
    
    EXTERN    w_pixeladdress


.bkrestore
._bkrestore
    push    ix
; __FASTCALL__ : sprite ptr in HL
    
    push    hl
    pop    ix

    ld    l,(ix+2)    ; x
    ld    h,(ix+3)
    ld    e,(ix+4)    ; y
    ;ld    d,(ix+5)
    ld    d,0
    
    ld    (x_coord+1),hl
    ld    c,e

    push    bc
    call    w_pixeladdress
    pop    bc

    ld    a,(ix+0)
    ld    b,(ix+1)
    
    dec    a
    srl    a
    srl    a
    srl    a
    inc    a
    inc    a    ; INT ((Xsize-1)/8+2)
    ld    (rbytes+1),a

.bkrestores
    push    bc
    
.rbytes
    ld    b,0
.rloop
    ld    a,(ix+6)
    ld    (de),a
    inc    de
    inc    ix
    djnz    rloop

    ld    d,0
    ld    e,c
    inc e    ; y
.x_coord
    ld    hl,0
    call    w_pixeladdress
    
    pop    bc
    inc c    ; y
    
    djnz    bkrestores
    pop    ix
    ret
ENDIF
