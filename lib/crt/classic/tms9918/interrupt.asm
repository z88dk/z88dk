	EXTERN	VDP_STATUS
    EXTERN  __tms9918_status_register

tms9918_interrupt:
    push    af
    push    hl
    ld      a, +(VDP_STATUS >> 16)
    and     a
    jr      z,read_port
    ld      a,(-VDP_STATUS)
    jr      done_read
read_port:
    in      a,(VDP_STATUS % 256)
done_read:
    ld      (__tms9918_status_register),a
    or      a
    jp      p,int_not_VBL
    jp      int_VBL

int_not_VBL:
    pop     hl
    pop     af
    ; Needs following with ei/reti or retn as appropriate
