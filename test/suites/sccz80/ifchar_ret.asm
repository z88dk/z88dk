; Char ABI: return in L. H and carry are not part of the value.
SECTION code_compiler

PUBLIC  _char_ret_l0_hjunk
PUBLIC  _char_ret_l1_hjunk

_char_ret_l0_hjunk:
    ld      h,170
    ld      l,0
    scf
    ret

_char_ret_l1_hjunk:
    ld      h,170
    ld      l,1
    and     a
    ret
