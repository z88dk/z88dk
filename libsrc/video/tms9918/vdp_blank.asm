
SECTION code_video_vdp

PUBLIC  vdp_blank
PUBLIC  _vdp_blank
PUBLIC  vdp_noblank
PUBLIC  _vdp_noblank


EXTERN  VDPreg_Write
EXTERN  RG1SAV
EXTERN  l_tms9918_disable_interrupts
EXTERN  l_tms9918_enable_interrupts

vdp_blank:
_vdp_blank:
    ld      e,@01000000
    jr      doit

vdp_noblank:
_vdp_noblank:
    ld      e,@00000000
doit:
    call    l_tms9918_disable_interrupts
    ld      a,(RG1SAV)
    and     @10111111
    or      e
    ld      e,1         ;Register 1
    call    VDPreg_Write
    call    l_tms9918_enable_interrupts
    ret


