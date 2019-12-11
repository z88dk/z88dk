

        SECTION code_graphics

        PUBLIC  w_pixeladdress_320
        PUBLIC  w_pixeladdress_640


; Entry:
;        hl = x
;        de = y
; Exit:
;        hl = address
;         a = bit number
;        fz = 1 if bit number is 0

w_pixeladdress_320:
        ld      b,l
        call    pixel_address
        ld      a,b
	xor	1
        and     1
        ret

w_pixeladdress_640:
        ; Reduce x down to the byte number
        ld      b,l        ;Save x
        srl     h        ;Max 640 on entry
        rr      l
        call    pixel_address
        ld      a,b
	xor	3
        and     3
        ret

; Get pixel address, hl = x (320 max), de = y
pixel_address:
        srl     h        ;Max 320 on entry
        rr      l
        ld      c,l ;This is in the range 0-160 now

        ex      de,hl        ;Now hl = y, need to remove lower 7 bits 
        ld      a,l  
        ex      af,af   ;Save lower 7 bits of row
        ld      a,l     ;So this value is already *8 in terms of character rows
        and     @11111000
        ld      l,a
        add     hl,hl        ;y * 16
        ld      d,h
        ld      e,l
        add     hl,hl        ;y * 32
        add     hl,hl        ;y * 64
        add     hl,de        ;y * 80
        add     hl,hl        ;y * 160
        ld      e,c
        ld      d,0
        add     hl,de        ;Now points to byte
        set     7,h        ;We need to point to > 32768

        ; Now we need to take the lower 7 bits and * $1000
        ex      af,af
        rlca
        rlca
        rlca
	rlca
        and     @01110000
        ld      d,a
        ld      e,0
        add     hl,de
        ld      a,l        ;Swap bytes so good for the port
        ld      l,h
        ld      h,a
        ret


        

