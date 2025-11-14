
    SECTION bss_clib

    PUBLIC __i64_acc
    PUBLIC __i64_extra

; Arranged this way so that division ends up with divisor in __i64_acc and
; dividend copied into __i64_extra
__i64_extra:	defs	8
__i64_acc:	defs	8
