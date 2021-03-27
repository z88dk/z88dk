;
;    Fast background save
;
;    Generic version (just a bit slow)
;
;    $Id: bksave2.asm $
;

IF !__CPU_INTEL__ & !__CPU_GBZ80__
    SECTION   code_clib
    
    PUBLIC    bksave
    PUBLIC    _bksave
    
    EXTERN    getsprite_sub


.bksave
._bksave
    
    push    ix
    ld    hl,4   
    add    hl,sp
    
    ld    e,(hl)
    inc    hl
    ld    d,(hl)
    inc    hl
    push    de    ;sprite address
    pop    ix
    
    ld    e,(hl)  
    inc    hl
    inc    hl
    ld    d,(hl)    ; x and y __gfx_coords

    ld    b,(ix+0)    ; x sz
    ld    c,(ix+1)    ; y sx
    inc ix
    inc ix
    ld    (ix+0),d    ; x pos
    ld    (ix+1),e    ; y pos
    inc ix
    inc ix
    
    ;  now we create the sprite struct
    ld    (ix+0),b    ; x sz
    ld    (ix+1),c    ; y sz

    
    jp getsprite_sub
ENDIF
