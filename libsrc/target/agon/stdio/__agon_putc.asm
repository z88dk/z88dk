
SECTION code_clib
PUBLIC __agon_putc


__agon_putc:
    defb    $49		;LIS
    rst     $10
    ret
