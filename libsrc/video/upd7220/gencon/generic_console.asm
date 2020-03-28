; Console driver for the UPD7220 (initially targetting BIC A5105)
;

        SECTION     code_clib

        PUBLIC      __upd7220_cls
        PUBLIC      __upd7220_scrollup
        PUBLIC      __upd7220_printc
        PUBLIC      __upd7220_set_ink
        PUBLIC      __upd7220_set_paper
        PUBLIC      __upd7220_set_attribute

        EXTERN      CONSOLE_COLUMNS
        EXTERN      CONSOLE_ROWS
        EXTERN      __upd7220_attr
        EXTERN      __upd7220_buffer
        EXTERN      __console_w

        INCLUDE     "video/upd7220/upd7220.inc"

IF UPD7220_EXPORT_DIRECT = 1
        PUBLIC      generic_console_cls
        defc        generic_console_cls = __upd7220_cls
        PUBLIC      generic_console_vpeek
        defc        generic_console_vpeek = __upd7220_vpeek
        PUBLIC      generic_console_scrollup
        defc        generic_console_scrollup = __upd7220_scrollup
        PUBLIC      generic_console_printc
        defc        generic_console_printc = __upd7220_printc
        PUBLIC      generic_console_set_ink
        defc        generic_console_set_ink = __upd7220_set_ink
        PUBLIC      generic_console_set_paper
        defc        generic_console_set_paper = __upd7220_set_paper
        PUBLIC      generic_console_set_attribute
        defc        generic_console_set_attribute= __upd7220_set_attribute
ENDIF

__upd7220_set_attribute:
    ret

__upd7220_set_paper:
    and     7
    rla
    rla
    rla
    rla
    rla	
    ld      e,a
    ld      a,(__upd7220_attr)
    and     @00011111
    or      e
    ld      (__upd7220_attr),a
    ret

__upd7220_set_ink:
    and     15
    ld      e,a
    ld      a,(__upd7220_attr)
    and     @11110000
    or      e
    ld      (__upd7220_attr),a
    ret

__upd7220_cls:
    di
    ld      hl, 0
    call    CURS2
    ld      de, +(CONSOLE_COLUMNS * CONSOLE_ROWS) - 1
    ld      hl,(__upd7220_attr - 1)
    ld      l,$20
cls_1:
    call    WDAT2
    dec     de
    ld      a,d
    or      e
    jr      nz,cls_1
    ei
    ret

; c = x
; b = y
; a = character to print
; e = raw
__upd7220_printc:
    di
    ex      af,af
    call    xypos
    call    CURS2
    ex      af,af
    ld      hl,(__upd7220_attr - 1)
    ld      l,a
    call    WDAT2
    ei
    ret

;Entry: c = x,
;       b = y
;Exit:  nc = success
;        a = character,
;        c = failure
__upd7220_vpeek:
    di
    call    xypos
    call    CURS2
    call    RDAT
    ld      a,l
    and     a
    ei
    ret

xypos:
    ld      hl,0
    ld      de,(__console_w)
    ld      d,0
    inc     b   
generic_console_printc_1:
    add     hl,de
    djnz    generic_console_printc_1
generic_console_printc_3:
    add     hl,bc           ;hl now points to address in display
    ret


__upd7220_scrollup:
    di
    push    de
    push    bc
    ld      b,24
    ld      hl,(__console_w)    ;We start from row 1
    ld      h,0
scroll_1:
    push    bc

    push    hl      ;Save cursor
    call    CURS2

    ld      a,(__console_w)
    ld      b,a
    ld      de,__upd7220_buffer
    call    READBLOCK
    pop     hl
    push    hl
    ld      de,(__console_w)
    ld      d,0
    and     a
    sbc     hl,de
    call    CURS2
    ld      b,e
    ld      de,__upd7220_buffer
    call    WRITEBLOCK
    pop     hl
    ld      de,(__console_w)
    ld      d,0
    add     hl,de
    pop     bc
    djnz    scroll_1
    and     a
    sbc     hl,de
    call    CURS2
    ld      b,e
scroll_2:
    push    bc
    ld      hl,(__upd7220_attr-1)
    ld      l,' '
    call    WDAT2
    pop     bc
    djnz    scroll_2

    pop     bc
    pop     de
    ei
    ret


; Output the CURS commnad
CURS2:
    call    ckstatus
    ld      a,UPD7220_COMMAND_CURS
write_2_command:
    out     (UPD_7220_COMMAND_WRITE),a
    ld      bc,UPD_7220_PARAMETER_WRITE
    out     (c),l
    out     (c),h
    ret

WDAT2:
    call    ckstatus
    ld      a,UPD7220_COMMAND_WDAT
    jr      write_2_command

ckstatus:
    in      a,(UPD_7220_STATUS_READ)
    and     2
    jr      nz,ckstatus
    ret

ckread:
    in      a,(UPD_7220_STATUS_READ)
    and     1
    jr      z,ckstatus
    ret


; Entry: de = address
;         b = length
READBLOCK:
    call    ckstatus
    ld      c,UPD_7220_PARAMETER_WRITE
    ld      a,UPD7220_COMMAND_FIGS
    out     (UPD_7220_COMMAND_WRITE),a
    ld      a,2
    out     (c),a       ;Left to right direction
    out     (c),b       ;width
    xor     a
    out     (c),a
    call    ckstatus
    ld      a,UPD7220_COMMAND_RDAT
    out     (UPD_7220_COMMAND_WRITE),a
    ex      de,hl
    ld      c,UPD_7220_FIFO_READ
    sla     b
READBLOCK_1:
    call    ckread
    ini
    jr      nz,READBLOCK_1
    ret

WRITEBLOCK:
    call    ckstatus
    ld      a,UPD7220_COMMAND_WDAT
    out     (UPD_7220_COMMAND_WRITE),a
    ex      de,hl
    ld      c,UPD_7220_PARAMETER_WRITE
    sla     b
WRITEBLOCK_1:
    call    ckstatus
    outi
    jr      nz,WRITEBLOCK_1
    ret



RDAT:
    ld      a,UPD7220_COMMAND_FIGS
    ld      hl,$0102
    call    write_2_command
    call    ckstatus
    ld      a,UPD7220_COMMAND_RDAT
    out     (UPD_7220_COMMAND_WRITE),a
    ld      bc,UPD_7220_FIFO_READ
    call    ckread
    in      l,(c)
    call    ckread
    in      h,(c)
    ret
