SECTION code_clib
PUBLIC open
PUBLIC _open
PUBLIC ___open

INCLUDE "target/agon/def/mos_api.inc"


; #define O_RDONLY  0
; #define O_WRONLY  1
; #define O_RDWR    2
; #define O_APPEND  256
; #define O_TRUNC   512
; #define O_CREAT   1024


open:
_open:
___open:
    push	ix
    ld      ix,2
    add     ix,sp
    ld      l,(ix+6)   
    ld      h,(ix+7)
    ld      a,(ix+4)
    ld      c,fa_read
    and     a       ;O_RDONLY
    jr      z,open_forreal
    ld      c,fa_write
    dec     a       ;O_WRONLY
    jr      z,open_forreal
    ld      c,fa_read|fa_write
    dec     a       ;O_RDWR
.open_forreal:
    ld      a,(ix+5)    ;high byte of flags
    ld      b,fa_open_append
    rrca                ;append
    jr      c,openit
    ld      b,fa_create_always
    rrca                ;trunc
    jr      c,openit
    ld      b,fa_create_new
    rrca                ;create
    jr      c,openit
    ld      b,0
openit:
    ld      a,b
    or      c
    ld      c,a
    MOSCALL(mos_fopen)
    pop     ix
    and     a
    ld      l,a
    ld      h,0
    ret     nz
    dec     hl  ;hl = -1
    ret