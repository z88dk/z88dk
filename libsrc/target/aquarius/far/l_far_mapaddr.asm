
;
; Map a banked address to a far pointer
;


SECTION code_l_sccz80_far
PUBLIC  l_far_mapaddr


; Entry: ehl = banked address
; Exit:  ehl = far address
l_far_mapaddr:
    ld      a,e    ; If banked address is 0x00nnnn, then address absolutely
    and     a 
    ret     z
    ld      d,0
    srl     e
    rr      d
    srl     e
    rr      d
    ld      a,h    ; Map to right offset in the 64k segment
    and     @00111111
    or      d
    ld      h,a
    ld      d,0
    ret


