;
;       Turtle graphics library
;       Stefano - 11/2017
;

    SECTION code_clib
    PUBLIC  turn_right
    PUBLIC  _turn_right

    EXTERN  l_sub

    EXTERN  __direction

.turn_right
._turn_right
    ; __FASTCALL

    ex      de,hl
    ld      hl,(__direction)
    add     hl,de
    ld      (__direction),hl

  IF __CPU_8085__
    ld      bc,360
    sub     hl,bc
  ELIF __CPU_8080__ || __CPU_GBZ80__
    ld      de,360
    ex      de,hl
    call    l_sub
  ELSE
    ld      de,360
    and     a
    sbc     hl,de
  ENDIF

    ret     c

    ld      (__direction),hl
    ret
