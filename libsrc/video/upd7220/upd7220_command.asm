

    SECTION     code_clib
    PUBLIC      __upd7220_command

    INCLUDE     "video/upd7220/upd7220.inc"

; Entry: a = command
;	hl = address to read bytes from
;	 b = number of bytes
__upd7220_command:
    call    ckstatus
    out     (UPD_7220_COMMAND_WRITE),a
command_1:
    call    ckstatus
    ld      a,(hl)
    inc     hl
    out     (UPD_7220_PARAMETER_WRITE),a
    djnz    command_1
    ret

ckstatus:
    ex      af,af
ckstatus1:
    in      a,(UPD_7220_STATUS_READ)
    and     2
    jr      nz,ckstatus1
    ex      af,af
    ret


