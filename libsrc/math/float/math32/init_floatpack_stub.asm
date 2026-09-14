; Stub for classic sccz80 48-bit float runtime initialisation.
; The 48-bit float helpers are pulled into 8080/8085/gbz80 CRT startup
; libraries and reference init_floatpack.  math32 builds do not use the
; 48-bit path, so a no-op stub is sufficient to satisfy the link.

SECTION code_crt_init
SECTION code_fp_math32

PUBLIC init_floatpack

init_floatpack:
    ret

