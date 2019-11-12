
    SECTION code_driver 

    PUBLIC  w_pixeladdress

    EXTERN  __x1_mode
    EXTERN  generic_console_xypos


; Entry  hl = x
;        de = y
; Exit: hl = de = address	
;	 a = pixel number
; Uses: a, bc, de, hl
; Blue at  $4000
; Red at   $8000
; Green at $c000
; We return the address for blue
.w_pixeladdress
	ld	b,l		;Save lower of x
    ld  c,e     ;Save lower of y

    ; Reduce x and y to character coordinates
    srl     h           ;->320
    rr      l
    rr      h           ;->160
    rr      l
    srl     l           ;->80
    srl     e           ;y -> 100
    srl     e           ;y -> 50
    srl     e           ;y -> 25
    push    bc          ;Save lower
    ld      b,e         ;row
    ld      c,l         ;column
    call    xypos       ;Returns hl = address
    pop     bc
    ld      a,c         ;Multiply the row within the cell by $800
    and     7
    rlca
    rlca
    rlca
    ld      d,a
    ld      e,0
    add     hl,de
    ld      a,b
    and     0x07
    xor     0x07
    ld      d,h
    ld      e,l
    ret

xypos:
    ld      l,b
    ld      h,0
    add     hl,hl
    add     hl,hl
    add     hl,hl   ;x8
    ld      e,l
    ld      d,h
    add     hl,hl
    add     hl,hl   ;x32
    add     hl,de   ;x40
    ld      a,(__x1_mode)
    and     a
    jr      z,mode0_xypos
    add     hl,hl   ;x80
mode0_xypos:
    ld      b,$40
    add     hl,bc   ;add on column + display base
    ret

