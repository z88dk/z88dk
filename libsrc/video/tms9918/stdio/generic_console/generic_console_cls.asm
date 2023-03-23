

    MODULE  __tms9918_cls
    SECTION code_video_vdp
    PUBLIC	__tms9918_cls

    EXTERN  __tms9918_cls_func

__tms9918_cls:
    ld      hl,(__tms9918_cls_func)
    jp      (hl)
