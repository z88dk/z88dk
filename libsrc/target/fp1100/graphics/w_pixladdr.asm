
    SECTION code_driver 

    PUBLIC  w_pixeladdress

    EXTERN  __fp1100_mode
    PUBLIC  __fp1100_plot_buffer

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
    push    bc          ;Save lower bits
    ld      b,e         ;row
    ld      c,l         ;column
    call    xypos       ;Returns hl = address
    ex      de,hl
    ld      hl,__fp1100_plot_buffer
    ld      (hl),e
    inc     hl
    ld      (hl),d
    inc     hl
    pop     bc
    ld      a,b         ;X coordinate
    and     0x07
    ld      (hl),a
    inc     hl
    ld      a,c         ;Multiply the row within the cell by $800
    and     7
    ld      (hl),a
    inc     hl
    ; Remaining 5 bytes, set to 0, may be used elsewhere
    ld      (hl),0
    inc     hl
    ld      (hl),0
    inc     hl
    ld      (hl),$D5
    inc     hl
    ld      (hl),0
    inc     hl
    ld      (hl),0
    ret


; Entry: b = row, c = coloumn
; Exit: hl = character offset
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
    ld      a,(__fp1100_mode)
    and     a
    jr      z,mode0_xypos
    add     hl,hl   ;x80
mode0_xypos:
    ld      b,0
    add     hl,bc   ;add on column + display base
    ret


    SECTION bss_clib

__fp1100_plot_buffer:    defs   9

