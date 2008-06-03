;
;       z88dk RS232 Function
;
;       Amstrad CPC (STI) version
;
;       unsigned char rs232_put(char)
;

; Fastcall so implicit push


                XLIB   rs232_put

rs232_put:
                ;;push af
                ld   bc,$f8ee
wait:           in   a,(c)
                bit  7,a
                jr   z,wait
                ld   c,$e1
cts:            in   a,(c)
                bit  2,a
                jr   nz,cts
                ;;pop  af
                ld      a,l     ;get byte
                ld   c,$ef
                out  (c),a
                ld   hl,0       ;RS_ERR_OK
                pop  bc         ;remove implicit push
                ret


