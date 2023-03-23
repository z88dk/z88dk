

    SECTION code_clib

    PUBLIC  __cpc_read_kbdrow
    EXTERN  l_push_di
    EXTERN  l_pop_ei

; Read a CPC keyboard row
;
; Preserves interrupt enabled status
;
; Entry: a = row
; Exit:  e = result of row
__cpc_read_kbdrow:
    ld    e,a
    call  l_push_di
    ld    a,e
    ld    bc, $F782  ;PPI port A out /C out
    out   (c), 0
    ld    bc, $F40E  ;Select AY register 14 on ppi port A
    out   (c), c
    ld    bc, $F6C0
    out   (c), c
    out   (c), 0
    ld    bc, $F792  ;PPI port A in/C out
    out   (c), c
    ld    c, a
    ld    b, $F6
    out   (c), c     ;Send keyboard line of register 14 ay via PPI port A
    ld    b, $F4
    in    a, (c)     ; Read ppi port A which is AY R14
    ld    bc, $F782  ; PPI port A out  C out
    out   (c), c
    dec   b
    out   (c), 0     ; Reset PPI write
    cpl
    ld    e,a
    call  l_pop_ei
    ret

