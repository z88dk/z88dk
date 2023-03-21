;
; Generic console function pointers for operations
;

SECTION data_video_vdp


PUBLIC  __tms9918_spec_funcs
PUBLIC  __tms9918_cls_func
PUBLIC  __tms9918_printc_func
PUBLIC  __tms9918_scroll_func
PUBLIC  __tms9918_spec_funcs_end


EXTERN  l_ret

__tms9918_spec_funcs:
__tms9918_cls_func:
    defw    l_ret
__tms9918_printc_func:
    defw    l_ret
__tms9918_scroll_func:
    defw    l_ret
__tms9918_spec_funcs_end:
