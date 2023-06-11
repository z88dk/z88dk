SECTION smc_clib

PUBLIC l_jpix, l_ix_addr
EXTERN l_ret

l_jpix:
    jp l_ret    ; The jp address is modified by l_setix.

    ; You MUST call l_setix first!
    ; This should never happen, but just in case it does.. l_ret

defc l_ix_addr = l_jpix+1

; use for library code only!
