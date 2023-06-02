
SECTION code_clib
PUBLIC  __agon_putc
PUBLIC  __agon_putword

__agon_putword:
    ld      a,l
    call    __agon_putc
    ld      a,h

__agon_putc:
    defb    $49		;LIS
    rst     $10
    ret
