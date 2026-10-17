; Rabbit far access: save the XPC window page
;
; Exit: a = current XPC (the entry value for __far_end)

    SECTION code_l_sccz80_far
    PUBLIC  __far_start

__far_start:
    ld      a,xpc
    ret
