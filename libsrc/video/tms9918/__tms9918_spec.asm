

SECTION data_clib

PUBLIC  __tms9918_terminal_spec
PUBLIC  __tms9918_spec_columns
PUBLIC  __tms9918_spec_rows
PUBLIC  __tms9918_spec_gfxw
PUBLIC  __tms9918_spec_gfxh
PUBLIC  __tms9918_spec_sprites_enabled
PUBLIC  __tms9918_spec_capabilities
PUBLIC  __tms9918_spec_end


PUBLIC  __tms9918_spec_funcs
PUBLIC  __tms9918_cls_func
PUBLIC  __tms9918_printc_func
PUBLIC  __tms9918_scroll_func
PUBLIC  __tms9918_spec_funcs_end


EXTERN  l_ret

__tms9918_terminal_spec:

__tms9918_spec_columns:
    defb    32
__tms9918_spec_rows:
    defb    32
__tms9918_spec_gfxw:
    defb    255
__tms9918_spec_gfxh:
    defb    191
__tms9918_spec_sprites_enabled:
    defb    1
__tms9918_spec_capabilities:
    defb    0
__tms9918_spec_end:

;; Should cls go in the spec?

__tms9918_spec_funcs:
__tms9918_cls_func:
    defw    l_ret
__tms9918_printc_func:
    defw    l_ret
__tms9918_scroll_func:
    defw    l_ret
__tms9918_spec_funcs_end:
