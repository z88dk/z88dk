

    SECTION bss_video_vdp

    PUBLIC  __tms9918_status_register


; Value of the status register - set by interrupt handler
__tms9918_status_register:
    defb    0
