



PUBLIC l_far_mapaddr

; Map between a __banked address to a far pointer
; Entry: ehl = banked address
; Exit:  ehl = far pointer
l_far_mapaddr:
     ld      d,0
     srl     e
     rr      d
     srl     e
     rr      d
     ld      a,h
     and     @00111111
     or      d
     ld      h,a
     ld      d,0
     ret
    
