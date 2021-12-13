;-------------------------------------------------------------------------
; Native terminal i/o functionality for micro8085_cilb (stdio interface)

        SECTION code_clib
        
        EXTERN _urxbuf
        EXTERN _getidx

        PUBLIC  getk
        PUBLIC  _getk

;-------------------------------------------------------------------------
; Function checks if buffer has data, if so it pulls one char from buffer
; Assumes buffer len is 256 bytes and that it's aligned to a 256 boundary
getk:
_getk:
        lhld    _getidx         ;read both get(l) and put(h)
        ld      a,l             ;compare them
        cp      h               ;if same no data
        jp      nz,getk1        ;else read from buf
        ld      hl,0            ;ret zero when no data
        ret                     ;with z-flag also set
getk1:  ld      h,_urxbuf/256   ;msb of buffer address
        ld      a,(hl)          ;pull from buffer
        ld      h,a             ;char temp to h
        ld      a,l             ;buffer index to a
        inc     a               ;bump index
        ld      (_getidx),a     ;store index
        or      l               ;clear z-fag
        ld      l,h             ;char to l
        ld      h,0             ;return in hl
        ret
