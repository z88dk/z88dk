;
; Drawbox sub for drawb(), undrawb(), xordrawb()
;
; Generic high resolution version
;
;
; $Id: w_drawbox.asm $
;

IF !__CPU_INTEL__
    SECTION code_graphics
    PUBLIC    drawbox

; IN:  HL,DE = (x,y).  HL' = width, DE' = height

.drawbox
    push hl
    push de
    exx
    push hl
    push de
    exx

    ;exx
    push de    ; y delta
    exx
    pop    bc    ; y delta
    
    exx
    push hl
    inc hl
.xloop1
    exx    
    call plot_sub    ; (hl,de)
    
    ex de,hl
    add hl,bc    ; y += delta
    ex de,hl

    call plot_sub    ; (hl,de)

    ex de,hl
    and a
    sbc hl,bc    ; y -= delta
    ex de,hl
    
    inc hl
    exx
    dec hl
    ld    a,h
    or    l
    jr    nz,xloop1
    
    pop hl    ; restore x
    exx
    
    
    pop    de    ; y
    pop hl
    exx
    pop    de    ; y delta
    pop hl
    push hl    ; x delta
    exx
    pop    bc    ; x delta

    inc de
    exx
    dec de
.yloop1
    exx    
    call plot_sub    ; (hl,de)
    
    add hl,bc    ; x += delta

    call plot_sub    ; (hl,de)
    
    and a
    sbc hl,bc    ; x -= delta
    
    inc de
    exx
    dec de
    ld    a,d
    or    e
    jr    nz,yloop1
    
    ret

    
    
    
    
.plot_sub
    push bc
    push hl
    push de
    ld    bc, p_RET1
    push    bc
    jp    (ix)    ;    execute PLOT at (hl,de)
.p_RET1
    pop de
    pop hl
    pop bc
    ret

ENDIF
