; Handling for printing in SAM modes

; SAM mode 1 - as per zx
;
; SAM mode 2 - linear
; 6144 bit patterns (32 bytes per row)
; attributes 8192 bytes apart (as per timex hires)
; 6144 byte attributes

; Sam mode 3
; 24576 bit patterns (128 bytes per row) - 512x192
; p0 = left
; p0 p0 p1 p1 p2 p2 p3

;Sam mode 4    
; 24576 - attr + bit - 256 x 192
;
; p0 p0 p0 p0 p1 p1 p1 p1

    MODULE  __sam_printc
    PUBLIC  __sam_printc
    PUBLIC  __sam_xypos_MODE3
    PUBLIC  __sam_xypos_MODE4


    EXTERN  __zx_32col_udgs
    EXTERN  __zx_32col_font
    EXTERN  generic_console_flags
    EXTERN  __zx_screenmode
    EXTERN  __zx_console_attr
    EXTERN  __sam_MODE3_attr
    EXTERN  __sam_MODE4_attr
    EXTERN  SCREEN_BASE

; Print on screen for MODE 2,3,4
;
; The screen mode change routine, only switches to here for these modes, mode 1 is handled
; by the standard +zx code, so there we get a choice of 32/64 characters
;
; Entry: b = y
;        c = x
;        d = character toprint
__sam_printc:
    ld      a,d         ;save character
    exx
    ld      bc,(__zx_32col_font)
    dec     b
    bit     7,a
    jr      z,handle_characters
    ld      bc,(__zx_32col_udgs)
    res     7,a
handle_characters:
    ld      l,a
    ld      h,0
    add     hl,hl
    add     hl,hl
    add     hl,hl
    add     hl,bc
    ld      a,(generic_console_flags)
    ld      b,a
    rlca
    sbc     a,a             ; ; c = 0/ c = 255
    ld      c,a
    exx    
    ; bc = b = y, c = x, coordinates to print at
    ; hl' = font
    ; c' = inverse flag
    ; b' = flags
    ld      a,(__zx_screenmode)
    cp      1
    jp      z,printc_MODE2
    cp      2
    jp      z,printc_MODE3
    ;; Fall through into printc_MODE4

; Mode 4: 16 colours per pixel
; p0 p0 p0 p0 p1 p1 p1 p1
printc_MODE4:
    call    __sam_xypos_MODE4
    ld      b,8
printc_MODE4_1:
    push    bc
    ld      a,b
    exx
    bit     3,b
    jr      z,printc_MODE4_no_underline
    cp      1
    jr      nz,printc_MODE4_no_underline
    ld      a,255
    jr      printc_MODE4_not_bold
printc_MODE4_no_underline:
    ld      a,(hl)
    xor     c
    bit     4,b
    ld      a,(hl)
    jr      z,printc_MODE4_not_bold
    rrca
    or      (hl)
printc_MODE4_not_bold:
    inc     hl
    exx
    

    ld      b,4
    ld      de,(__sam_MODE4_attr)    ;e = ink, d = paper
printc_MODE4_2:
    push    bc
    ; We have two bits per byte, so lets unroll a bit
    rlca
    ld      c,d    ;paper
    jr      nc,printc_MODE4_is_paper
    ld      c,e    ;ink
printc_MODE4_is_paper:
    rlca        ;shift again
    ld      b,a    ;save it
    ld      a,d
    jr      nc,printc_MODE4_is_paper2
    ld      a,e    ;ink
printc_MODE4_is_paper2:
    rrca
    rrca
    rrca
    rrca
    and     0x0f
    or      c
    ld      (hl),a
    inc     hl
    ld      a,b
    pop     bc
    djnz    printc_MODE4_2
    ld      de,128 - 4
    add     hl,de
    pop     bc
    djnz    printc_MODE4_1
    ret




;p0 p0 p1 p1 p2 p2 p3
printc_MODE3:
    call    __sam_xypos_MODE3
    ld      b,8
printc_MODE3_1:
    push    bc
    ld      a,b
    exx
    bit     3,b
    jr      z,printc_MODE3_no_underline
    cp      1
    jr      nz,printc_MODE3_no_underline
    ld      a,255
    jr      printc_MODE3_not_bold
printc_MODE3_no_underline:
    ld      a,(hl)
    xor     c
    bit     4,b
    ld      a,(hl)
    jr      z,printc_MODE3_not_bold
    rrca
    or      (hl)
printc_MODE3_not_bold:
    inc     hl
    exx

    ld      b,2
printc_MODE3_2:
    ld      de,(__sam_MODE3_attr)    ;e = ink, b = paper
    push    bc
    push    hl
    ld      l,a
    ld      b,4    ;4 iterations
    ld      c,0    ;final byte
printc_MODE3_3:
    rl      l
    ld      a,d
    jr      nc,is_paper
    ld      a,e
is_paper:
    or      c
    ld      c,a
    srl     d
    srl     d
    srl     e
    srl     e
    djnz    printc_MODE3_3
    ld      a,l    ;Save the character for a moment
    pop     hl
    ld      (hl),c
    inc     hl
    pop     bc
    djnz    printc_MODE3_2
    ld      de,128 - 2
    add     hl,de
    pop     bc
    djnz    printc_MODE3_1
    ret



; Mode 2 linear 32x192, attributes +8k
; Entry:  b = y
;         c = x
;       hl' = font entry to print
;        c' = inverse mask
;        b' = flags
printc_MODE2:
    ; Each character row is 8*32 = 256 bytes
    ld      a,+(SCREEN_BASE / 256)
    add     b
    ld      h,a
    ld      l,c
    ld      de,32
    ld      a,(__zx_console_attr)
    ld      c,a
    ld      b,8
print32_loop:
    exx
    bit     4,b
    ld      a,(hl)
    jr      z,no_32_bold
    rrca
    or      (hl)
no_32_bold:
    xor     c
    inc     hl
    exx
    ld      (hl),a
    set     5,h
    ld      a,(__zx_console_attr)
    ld      (hl),c
    res     5,h
    add     hl,de
    djnz    print32_loop
handle_attributes:
    ; hl holds address of line of character below, lets go back
    exx
    bit     3,b
    ret     z
    exx
    and     a
    sbc     hl,de
    ld      a,255
    ld      (hl),a
    ret


; convert character x,y to address
; Entry: b = row
;        c = column
;
;Mode 3,4; Char rows are 1024 bytes
__sam_xypos_MODE4:
    ld      a,b
    add     a
    add     a       ;*4
    add     +(SCREEN_BASE / 256)
    ld      h,a     ;Row * 1024 + screen base
    ; Now, how many bytes per character?
    sla     c
    sla     c       ;4 bytes needed for a character
    ld      l,c
    ret

__sam_xypos_MODE3:
    ld      a,b
    add     a
    add     a       ;*4
    add     +(SCREEN_BASE / 256)
    ld      h,a     ;Row * 1024 + screen base
    ; Now, how many bytes per character?
    ld      a,c
    add     a
    ld      l,a
    ret
    
