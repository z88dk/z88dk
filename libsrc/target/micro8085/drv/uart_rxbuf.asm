;-------------------------------------------------------------------------
; Native terminal i/o functionality for micro8085_cilb operates on buffer
; Functions below assumes support for INTEL 8085 "undocumented" opcodes
; Assumes buffer len is 256 bytes and that it's aligned to a 256 boundary

        SECTION code_clib
        
        EXTERN _urxbuf
        EXTERN _getidx

        PUBLIC  _uart_rxlen
        PUBLIC  _uart_rxget

;-------------------------------------------------------------------------
; extern uint16 uart_rxlen(void);
; returns number of bytes available to pull from uart rx buffer
_uart_rxlen:
        lhld    _getidx         ;read both get(l) and put(h)
        ld      a,h             ;length of buffer
        sub     l               ;equals putidx - getidx
        ld      l,a             ;ret val in (h)l
        ld      h,0             ;high byte always 0
        ret

;-------------------------------------------------------------------------
; extern uint16 uart_rxget(uint8 *pData, uint16 maxlen);
; returns number of pulled bytes from buf to supplied dest ptr and max len
_uart_rxget:
        ld      de,sp+2         ;get arguments from stack
        ld      hl,(de)         ;last pushed is length
        ld      b,h             ;copy maxlen
        ld      c,l             ;to bc
        inc     de              ;get to first
        inc     de              ;argument position
        ld      hl,(de)         ;first pushed is ptr
        ld      d,h             ;copy ptr
        ld      e,l             ;to de
        call    _uart_rxlen     ;actual buf len to hl
        call    chlbc           ;compare actual - max
        jp      nc,rxbuf1       ;jmp if actual >= max
        ld      b,h             ;copy actual len to bc
        ld      c,l             ;it was less than max
rxbuf1: push    bc              ;save for return val
        ld      a,(_getidx)     ;read get index
        ld      l,a             ;lsb of index to l
        ld      h,_urxbuf/256   ;msb of buffer address
rxbuf2: dec     bc              ;pre decr to use k flag
        jp      k,rxbuf3        ;k true when done
        ld      a,(hl)          ;pull from buffer
        ld      (de),a          ;put to destination
        inc     l               ;incr src loc low byte
        inc     de              ;incr dest location
        jp      rxbuf2          ;and loop
rxbuf3: ld      a,l             ;buffer index to a
        ld      (_getidx),a     ;store index
        pop     hl              ;return in hl
        ret

;-------------------------------------------------------------------------
;     compare hl - bc
; no carry if hl >= bc
;    carry if hl < bc
chlbc:  ld      a,h             ;compare hl - bc
        cp      b               ;and return
        ret     nz              ;correct c
        ld      a,l             ;and z
        cp      c               ;flags
        ret
