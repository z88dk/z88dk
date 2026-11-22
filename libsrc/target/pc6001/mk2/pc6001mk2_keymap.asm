; The sub-CPU's key codes to the codes getk and fgetc_cons return (a module of
; its own: a program that only calls pc6001mk2_key_take() does not link it).

    SECTION     code_clib
    PUBLIC      __pc6001mk2_key_map

; The sub-CPU's code in a to the code getk returns, in a: the cursor keys 8 left,
; 9 right, 10 down, 11 up as the other targets have them, backspace 12 (delete),
; the function keys and kana (from $80 up) nothing.  z if nothing.
__pc6001mk2_key_map:
    cp          $1d
    jr          nz, not_left
    ld          a, 8
    and         a                       ; (nz: a key)
    ret
not_left:
    cp          $1c
    jr          nz, not_right
    ld          a, 9
    and         a                       ; (nz: a key)
    ret
not_right:
    cp          $1f
    jr          nz, not_down
    ld          a, 10
    and         a                       ; (nz: a key)
    ret
not_down:
    cp          $1e
    jr          nz, not_up
    ld          a, 11
    and         a                       ; (nz: a key)
    ret
not_up:
    cp          $7f
    jr          nz, not_delete
    ld          a, 12
    and         a                       ; (nz: a key)
    ret
not_delete:
    cp          $80
    ret         c
    xor         a
    ret
