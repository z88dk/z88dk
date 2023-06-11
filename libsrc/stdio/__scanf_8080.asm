SECTION code_clib


IF __CPU_INTEL__

PUBLIC  __scanf_increment_conversions
PUBLIC  __scanf_increment_bytesread
PUBLIC  __scanf_decrement_bytesread
PUBLIC  __scanf_get_fp
PUBLIC  __scanf_check_suppressed
PUBLIC  __scanf_check_sign
PUBLIC  __scanf_check_width
PUBLIC  __scanf_check_long
PUBLIC  __scanf_set_width
PUBLIC  __scanf_get_width
PUBLIC  __scanf_set_signflag
PUBLIC  __scanf_set_longflag
PUBLIC  __scanf_set_suppressed
PUBLIC  __scanf_reset_flags
PUBLIC  __scanf_context


__scanf_increment_conversions:
    push    hl
    ld      hl,(__scanf_context)
    dec     hl
    inc     (hl)
    pop     hl
    ret

__scanf_increment_bytesread:
    ld      hl,(__scanf_context)
    ld      de,-6
    add     hl,de
    and     a
    inc     (hl)
    ret     nz
    inc     hl
    inc     (hl)
    ret

__scanf_decrement_bytesread:
    ld      hl,(__scanf_context)
    ld      de,-6
    add     hl,de
    ld      e,(hl)
    inc     hl
    ld      d,(hl)
    dec     de
    ld      (hl),d
    dec     hl
    ld      (hl),e
    and     a
    ret


__scanf_get_fp:
    push    de
    ld      hl,(__scanf_context)
    ld      de,8
    add     hl,de
    ld      e,(hl)
    inc     hl
    ld      d,(hl)
    ex      de,hl
    pop     de
    ret

; Check whether assignment is suppressed
; Ret: z/nz
; Uses: af
__scanf_check_suppressed:
    ld      a,8         ;bit 3
    jp      __scanf_check_flag

__scanf_check_sign:
    ld      a,1
    jp      __scanf_check_flag

__scanf_check_width:
    ld      a,4
    jp      __scanf_check_flag

__scanf_check_long:
    ld      a,2
    
__scanf_check_flag:
    push    hl
    ld      hl,(__scanf_context)
    dec     hl
    dec     hl
    dec     hl
    and     (hl)
    pop     hl
    ret

; e = width
; +set flags
__scanf_set_width:
    push    hl
    ld      hl,(__scanf_context)
    dec     hl
    dec     hl
    dec     hl
    ld      a,(hl)
    or      4           ;bit 2
    ld      (hl),a
    dec     hl          ;-4
    ld      (hl),e
    pop     hl
    ret

; Exit: b = width
__scanf_get_width:
    push    hl
    ld      hl,(__scanf_context)
    dec     hl
    dec     hl
    dec     hl
    ld      a,(hl)
    and     4
    jp      z,no_width
    dec     hl      ;ix-4
    ld      b,(hl)
no_width:
    pop     hl
    ret

__scanf_set_signflag:
    ld      a,1
    jp      __scanf_set_flags

__scanf_set_longflag:
    ld      a,2
    jp      __scanf_set_flags

__scanf_set_suppressed:
    ld      a,8        ;bit 3

__scanf_set_flags:
    push    hl
    ld      hl,(__scanf_context)
    dec     hl
    dec     hl
    dec     hl
    or      (hl)
    ld      (hl),a
    pop     hl
    ret

__scanf_reset_flags:
    push    hl
    ld      hl,(__scanf_context)
    dec     hl
    dec     hl
    dec     hl
    ld      (hl),0
    pop     hl
    ret


SECTION bss_clib

__scanf_context:   defw 0

ENDIF
