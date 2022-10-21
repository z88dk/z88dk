SECTION smc_clib

PUBLIC l_jpiy, l_jpiy_addr
EXTERN l_ret

l_jpiy:
    jp l_ret    ; The jp address is modified by l_setiy.

    ; You MUST call l_setiy first!
    ; This should never happen, but just in case it does.. l_ret

defc l_jpiy_addr = l_jpiy+1

; use for library code only!
