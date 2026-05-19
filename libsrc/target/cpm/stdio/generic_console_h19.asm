;
; Generic console that maps into "VT52" terminal codes
; (the Heath/Zenith H19 was a VT52 superset)
;
; CP/M version.  It is very similar to the HDOS one
; but the HDOS system requires a different initialization approach.
;
; We maintain a "back screen" so that vpeek will work
; 

    MODULE      generic_console_H19
    SECTION     code_clib

    PUBLIC      generic_console_cls_h19
    PUBLIC      generic_console_vpeek_h19
    PUBLIC      generic_console_scrollup_h19
    PUBLIC      generic_console_printc_h19
    PUBLIC      generic_console_ioctl_h19
    PUBLIC      generic_console_set_ink_h19
    PUBLIC      generic_console_set_paper_h19
    PUBLIC      generic_console_set_attribute_h19

    PUBLIC      generic_console_plotc
    PUBLIC      generic_console_pointxy

    EXTERN      CONSOLE_COLUMNS
    EXTERN      CONSOLE_ROWS
    EXTERN      __bdos

    INCLUDE     "ioctl.def"
    PUBLIC      CLIB_GENCON_CAPS
    defc        CLIB_GENCON_CAPS = CAP_GENCON_INVERSE


;;    defc        generic_console_cls = generic_console_cls_h19
;;    defc        generic_console_vpeek = generic_console_vpeek_h19
;;    defc        generic_console_scrollup = generic_console_scrollup_h19
;;    defc        generic_console_printc = generic_console_printc_h19
;;    defc        generic_console_ioctl = generic_console_ioctl_h19
;;    defc        generic_console_set_ink = generic_console_set_ink_h19
;;    defc        generic_console_set_paper = generic_console_set_paper_h19
;;    defc        generic_console_set_attribute = generic_console_set_attribute_h19



generic_console_set_attribute_h19:
    rra
    ld      a,'q'      ; Inverse OFF
    jr      nc, noinv
    dec     a          ; Inverse ON
noinv:
    push    af
    ld  e,27
    ld  c,2
    call    __bdos
    pop     af
    ld  e,a
    ld  c,2
    call    __bdos

generic_console_ioctl_h19:
    scf
    ret


generic_console_set_ink_h19:
    ret

generic_console_set_paper_h19:
    ret

generic_console_cls_h19:
    ld  hl,h19_backbuffer
    ld  de,h19_backbuffer+1
    ld  bc,+(CONSOLE_ROWS * CONSOLE_COLUMNS) - 1
    ld  (hl),0
    ldir

    ld  e,27
    ld  c,2
    call    __bdos
    ld  e,'q'       ; Inverse OFF
    ld  c,2
    call    __bdos

    ld  e,27
    ld  c,2
    call    __bdos
    ld  e,'E'       ;clear screen/home cursor
    ld  c,2
    call    __bdos

    ld    a,CONSOLE_ROWS
    cp    25
    jr    nz,no_25
    ld  e,27
    ld  c,2
    call    __bdos
    ld  e,'x'
    ld  c,2
    call    __bdos
    ld  e,1
    ld  c,2
    call    __bdos
no_25:

    ; TODO:   hide the cursor when in graphics mode
;    ld  e,27       ;hide cursor
;    ld  c,2
;    call    __bdos
;    ld  e,'x'
;    ld  c,2
;    call    __bdos
;    ld  e,5
;    ld  c,2
;    call    __bdos

;;    ld      l, 27                       ; ESC
;;    call    __sendchar
;;    ld      l, 'x'                      ; set mode
;;    call    __sendchar
;;    ld      l, '5'                      ; "cursor off"
;;    call    __sendchar
    
    ret


generic_console_scrollup_h19:
    push    de
    push    bc
    ld  hl,h19_backbuffer + CONSOLE_COLUMNS
    ld  de,h19_backbuffer
    ld  bc,+((CONSOLE_ROWS-1) * CONSOLE_COLUMNS)
    ldir
    ex  de,hl
    ld  b,CONSOLE_COLUMNS
cls_1:
    ld  (hl),32
    inc hl
    djnz    cls_1
    
;  ; cursor pos
    ld  e,27
    ld  c,2
    call    __bdos
    ld  e,'Y'
    ld  c,2
    call    __bdos
    ld  e,32+23
    ld  c,2
    call    __bdos
    ld  e,32
    ld  c,2
    call    __bdos

    ld  e,10
    ld  c,2
    call    __bdos

    ld    a,CONSOLE_ROWS
    cp    25
    jr    nz,no_forcecopy


    ld    hl,h19_backbuffer+80*23
    ld    b,80
;   ld    c,0
bottom_loop:
    push  hl
    push  bc

    ld    a,(hl)
    cp     128
    jr     c,skip_graphics
    push   af
    ld  e,27
    ld  c,2
    call    __bdos
    ld  e,'F'       ; "enter graphics mode"
    ld  c,2
    call    __bdos
    pop   af
    sub     34      ; remap to graphics symbols. 128 -> 94, and so on
skip_graphics:

    ld  e,a
    ld  c,2
    call    __bdos

    push   af
    ld  e,27
    ld  c,2
    call    __bdos
    ld  e,'G'       ; "exit graphics mode"
    ld  c,2
    call    __bdos
    pop   af

    pop   bc
    pop   hl
    inc   hl
;   inc   c
    djnz  bottom_loop

;  Wipe 25th row
    ld  e,27
    ld  c,2
    call    __bdos
    ld  e,'Y'
    ld  c,2
    call    __bdos
    ld  e,32+24
    ld  c,2
    call    __bdos
    ld  e,32+0
    ld  c,2
    call    __bdos

    ld    b,80
bottom_blank:
    push  bc
    push  hl
    ld  e,' '
    ld  c,2
    call    __bdos
    pop   hl
    pop   bc
    djnz  bottom_blank
    
no_forcecopy:
    pop   bc
    pop   hl
    ret



; c = x
; b = y
; a = character to print
; e = raw
generic_console_printc_h19:

    push    af
    push    bc
    call    h19_xypos
    ld      (hl),a

   ; cursor pos
    ld  e,27
    ld  c,2
    call    __bdos
    ld  e,'Y'
    ld  c,2
    call    __bdos

    pop    bc
    push   bc
    ld     a,32
    add    b
    ld  e,a
    ld  c,2
    call    __bdos

    pop    bc
    ld     a,32
    add    c
    ld  e,a
    ld  c,2
    call    __bdos

    ; send actual character
    pop    af
    cp     128
    jr     nc,graphics
    ld  e,a
    ld  c,2
    call    __bdos
    ret

graphics:
    push   af
    ld  e,27
    ld  c,2
    call    __bdos
    ld  e,'F'             ; "enter graphics mode"
    ld  c,2
    call    __bdos

    pop     af
    sub     34                          ; remap to graphics symbols. 128 -> 94, and so on
    ld  e,a
    ld  c,2
    call    __bdos
    
    ld  e,27
    ld  c,2
    call    __bdos
    ld  e,'G'             ; "exit graphics mode"
    ld  c,2
    call    __bdos
    ret


;Entry: c = x,
;       b = y
;       e = rawmode
;Exit:  nc = success
;        a = character,
;        c = failure
generic_console_pointxy:
generic_console_vpeek_h19:
    call    h19_xypos
    ld  a,(hl)
    and a
    ret


; c = x
; b = y
; a = d = character to print
; e = raw
generic_console_plotc:
    push    af
    push    bc
    call    h19_xypos
    ld      (hl),a

   ; cursor pos
    ld  e,27
    ld  c,2
    call    __bdos
    ld  e,'Y'
    ld  c,2
    call    __bdos

    pop    bc
    push   bc
    ld     a,32
    add    b
    ld  e,a
    ld  c,2
    call    __bdos

    pop    bc
    ld     a,32
    add    c
    ld  e,a
    ld  c,2
    call    __bdos

    ; inverse ON/OFF
    ld  e,27
    ld  c,2
    call    __bdos

    pop    af
    ; Test inverse symbol flag (for graphics we use bit 6)
    ld     e,a
    and    64
    push   de
    ld      a,'q'  ; Inverse OFF
    jr     z,no_inv
    dec    a       ; Inverse ON
no_inv:
    ld  e,a
    ld  c,2
    call    __bdos
    pop    de
    ld     a,e

    ; Now remove the 'inverse' flag and deal with the character/symbol
    and    10111111b  ; reset bit 6

    cp     128
    jr     nc,g_graphics
    ld  e,a
    ld  c,2
    call    __bdos
    
    ;ld      a,'q'  ; Inverse OFF
    ;rst    38h
    ;defb   SCOUT
    ret

g_graphics:
    push   af
    ld  e,27
    ld  c,2
    call    __bdos
    ld      e, 'F'                      ; "enter graphics mode"
    ld  c,2
    call    __bdos

    pop     af
    sub     34                          ; remap to graphics symbols. 128 -> 94, and so on
    ld  e,a
    ld  c,2
    call    __bdos
    
    ld  e,27
    ld  c,2
    call    __bdos
    ld      e, 'G'                      ; "exit graphics mode"
    ld  c,2
    call    __bdos
    ;ld      a,'q'  ; Inverse OFF
    ;rst    38h
    ;defb   SCOUT
    ret



h19_xypos:
    ld      hl,h19_backbuffer - CONSOLE_COLUMNS
    ld      de,CONSOLE_COLUMNS
    inc     b
generic_console_printc_1:
    add     hl,de
    djnz    generic_console_printc_1
generic_console_printc_3:
    add     hl,bc                   ;hl now points to address in display
    ret


;; h19_sendchar:
;; _h19_sendchar:
;; 
;; ; ..using the BIOS
;;     push    bc
;;     push    de
;; 
;;     ld      c, l
;;     ld      de, 9                       ; shift ptr to CONOUT
;;     ld      hl, (1)                     ; WBOOT (BIOS)
;;     add     hl, de
;;     call    __chl
;; 
;; ret_addr:
;;     pop     de
;;     pop     bc
;;     ret
;; 
;; __chl:
;;     jp      (hl)



    SECTION bss_clib

h19_backbuffer:    
    defs    80 * 25
