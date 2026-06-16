; 10F - forward reference with extern but never defined (allowed)
; Produces a relocation to an external symbol.
    extern x
    ld a,(x)
