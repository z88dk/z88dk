
SECTION code_video_vdp

INCLUDE "video/tms9918/vdp.inc"

IFDEF V9938

PUBLIC  __v9938_cmd_execute_direct

EXTERN  l_tms9918_disable_interrupts
EXTERN  l_tms9918_enable_interrupts
EXTERN  __v9938_wait_vdp

; _v9938_cmd_execute_direct(void *start, int first_Reg, int count)
;
; Count excludes the actual operation 
__v9938_cmd_execute_direct:
    push    ix
    ld      ix,4
    add     ix,sp   ;points to &count

    call    l_tms9918_disable_interrupts
    push    bc
    call    __v9938_wait_vdp

IF VDP_CMD >= 256
    ld      bc,VDP_CMD
ENDIF

    ld      a,(ix+2)        ;First register
    VDPOUT(VDP_CMD)
    ld      a,17+$80
    VDPOUT(VDP_CMD)         ;Set R#17, so we can start writing there

IF VDP_PORT3 >= 256
    ld      bc,VDP_PORT3
ENDIF
    ld      l,(ix+4)
    ld      h,(ix+5)
    ld      e,(ix+0)
    inc     e           ;Send the command as well
loop:
    ld      a,(hl)
    VDPOUT(VDP_PORT3)
    inc     hl
    dec     e
    jr      nz,loop
    ; Check if we should wait for the command to finish
    ld      a,(hl)
    call    nz,__v9938_wait_vdp
    call    l_tms9918_enable_interrupts
    pop     ix
    ret

ENDIF


