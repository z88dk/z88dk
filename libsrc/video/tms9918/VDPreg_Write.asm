SECTION code_video_vdp

PUBLIC VDPreg_Write

EXTERN l_tms9918_disable_interrupts
EXTERN l_tms9918_enable_interrupts

EXTERN RG0SAV


INCLUDE  "video/tms9918/vdp.inc"

; *** WRTVDP ***
; Copy a value into VDP reg
; IN: E = reg, A = val
;»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»
VDPreg_Write:  
;»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»

    push  hl
    ld    d,a
    call  l_tms9918_disable_interrupts
IF VDP_CMD >= 256
    ld      bc,VDP_CMD
ENDIF

    ld      a,d
    VDPOUT(VDP_CMD)
    ld      a,e
    or      $80        ; enable bit for "set register" command
    VDPOUT(VDP_CMD)

IFDEF V9938
    ld      a,e
    cp      24
    jr      nc,dont_store
ELSE
    ld      a,e
    cp      8
    jr      nc,dont_store
ENDIF
    ld      a,d
    ld      hl,RG0SAV
    ld      d,0
    add     hl,de
    ld      (hl),a
dont_store:
    inc     e
    call    l_tms9918_enable_interrupts
    pop     hl
    ret

