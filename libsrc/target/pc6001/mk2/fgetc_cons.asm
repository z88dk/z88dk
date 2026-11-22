;
;	NEC PC-6001mkII fgetc_cons() Wait for a key
;
;	As getk(): the ROM's routine on a cartridge, and on the boot disc the
;	keyboard interrupt's (the processor halts between interrupts, so they must
;	be on, as the library leaves them).
;

    SECTION     code_clib
    PUBLIC      fgetc_cons
    PUBLIC      _fgetc_cons
    EXTERN      pc6001mk2_key_take
    EXTERN      __pc6001mk2_key_map
    EXTERN      __pc6001mk2_disc

fgetc_cons:
_fgetc_cons:
    ld          a, __pc6001mk2_disc
    and         a
    jr          nz, disc
rom:
    call        $0FBC
    jr          z, rom
    jr          key_got
disc:
    call        pc6001mk2_key_take
    jr          nz, got
    halt
    jr          disc
got:
    call        __pc6001mk2_key_map
    jr          z, disc                 ; (a key with no code: wait for another)
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
