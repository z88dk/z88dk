;
;       Turtle graphics library
;       Stefano - 11/2017
;

    SECTION code_clib
    PUBLIC  turn_left
    PUBLIC  _turn_left

    EXTERN  l_sub

    EXTERN  __direction

.turn_left
._turn_left
    ; __FASTCALL

  IF __CPU_8085__
    ld      bc,hl
    ld      hl,(__direction)
    sub     hl,bc
  ELIF __CPU_8080__ || __CPU_GBZ80__
    ex      de,hl
    ld      hl,(__direction)
    ex      de,hl
    call    l_sub
  ELSE
    ex      de,hl
    ld      hl,(__direction)
    and     a
    sbc     hl,de
  ENDIF

    ld      (__direction),hl
    ret     nc

    ld      de,360
    add     hl,de
    ld      (__direction),hl
    ret
