

	SECTION	code_driver

	PUBLIC	dodos_residos

        INCLUDE "target/zx/def/idedos.def"

;
; This is support for residos, we use the normal
; +3 -lplus3 library and rewrite the values so
; that they suit us somewhat
dodos_residos:
        exx
        push    iy
        pop     hl
        ld      b,PKG_IDEDOS
        rst     RST_HOOK
        defb    HOOK_PACKAGE
        ld      iy,23610
        ret
