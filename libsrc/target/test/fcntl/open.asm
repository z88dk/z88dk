; Dummy function to keep rest of libs happy
;
; $Id: open.asm,v 1.6 2016-03-06 21:39:54 dom Exp $
;

                SECTION code_clib
                INCLUDE "target/test/def/test_cmds.def"

                PUBLIC  open
                PUBLIC  _open
                PUBLIC  ___open

; char *name, int flags, mode_t mode)
.open
._open
.___open
        ld      hl,2
        add     hl,sp
        ld      c,(hl)
        inc     hl
        ld      b,(hl)
        inc     hl
        ld      e,(hl)
        inc     hl
        ld      d,(hl)
        inc     hl
        ld      a,(hl)
        inc     hl
        ld      h,(hl)
        ld      l,a
        ld      a,CMD_OPENF
        call    SYSCALL
        ret
