; Rabbit far access: restore the XPC window page
;
; Entry: a = XPC saved by __far_start

    SECTION code_l_sccz80_far
    PUBLIC  __far_end

__far_end:
    ld      xpc,a
    ret
