
#include <stdio.h>
#include <sys/ioctl.h>

int console_ioctl(uint16_t cmd, void *arg) __naked 
{
#asm
    EXTERN  generic_console_ioctl
    EXTERN  __console_w
    EXTERN  generic_console_flags
    EXTERN  generic_console_caps

; fputc_cons_generic_ioctl(uint16_t request, void *arg) __smallc;
; Request at the moment is 8 bits
    ld      hl,2
    add     hl,sp
    ld      e,(hl)  ;arg
    inc     hl
    ld      d,(hl)
    inc     hl
    ld      a,(hl)  ;request
    ; Deal with generic ioctls here
    cp      IOCTL_GENCON_RAW_MODE
    jr      z,set_raw
    cp      IOCTL_GENCON_CONSOLE_SIZE
    jr      z,get_console_size
    push	de
    push	af
    call    generic_console_ioctl
    jr      nc,success_pop
    pop     af
    pop     de
    cp      IOCTL_GENCON_GET_CAPS
    jr      nz,failure
    ld      a,(generic_console_caps)
    ld      (de),a
    inc     de
    xor     a
    ld      (de),a
    jr      success
failure:
    ld      hl,-1
    ret
success_pop:
    pop     de
    pop     af
success:
    ld      hl,0
    ret

set_raw:
    ld      hl,generic_console_flags
IF __CPU_INTEL__
    ld      a,(hl)
    and     @11111110
    ld      (hl),a
ELSE
    res     0,(hl)
ENDIF
    ld      a,(de)
    and     a
    jr      z,success
IF __CPU_INTEL__
    ld      a,(hl)
    or      @00000001
    ld      (hl),a
ELSE
    set     0,(hl)
ENDIF
    jr      success

get_console_size:
IF __CPU_GBZ80__
    ld      hl,__console_w
    ld      a,(hl+)
    ld      h,(hl)
    ld      l,e
    ld      e,a
    ld      a,h
    ld      h,d
    ld      d,a
ELSE
    ld      hl,(__console_w)
    ex      de,hl           ;hl = arg
ENDIF
    ld      (hl),e
    inc     hl
    ld      (hl),d
    jr      success

#endasm
}
