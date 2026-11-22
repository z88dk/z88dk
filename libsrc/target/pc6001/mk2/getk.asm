;
;	NEC PC-6001mkII getk() Read key status
;
;	On a cartridge (-subtype=rom -clib=mk2) the ROM's keyboard routine; on the
;	boot disc, with the ROM mapped out, the code of the last key (see
;	pc6001mk2_key.asm), or 0 if there was none since the last call.
;

    SECTION     code_clib
    PUBLIC      getk
    PUBLIC      _getk
    EXTERN      pc6001mk2_key_take
    EXTERN      __pc6001mk2_key_map
    EXTERN      __pc6001mk2_disc

getk:
_getk:
    ld          a, __pc6001mk2_disc
    and         a
    jr          nz, disc
    call        $0FBC
    jr          nz, key_got
    xor         a
    jr          key_got
disc:
    call        pc6001mk2_key_take
    call        nz, __pc6001mk2_key_map
key_got:
  IF    STANDARDESCAPECHARS
    cp          13
    jr          nz, not_return
    ld          a, 10
not_return:
  ENDIF
    ld          l, a
    ld          h, 0
    ret
