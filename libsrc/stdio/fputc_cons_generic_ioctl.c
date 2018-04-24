
#include <stdio.h>
#include <sys/ioctl.h>

int fputc_cons_generic_ioctl(uint16_t cmd, void *arg) __naked 
{
#asm
	EXTERN		generic_console_ioctl
	EXTERN		generic_console_w
	EXTERN		generic_console_flags

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
	cp	IOCTL_GENCON_RAW_MODE
	jr	z,set_raw
        cp      IOCTL_GENCON_CONSOLE_SIZE
        jr      nz,get_console_size
	call	generic_console_ioctl
	jr	nc,success
failure:
	ld	hl,-1
        ret
success:
	ld	hl,0
	ret

set_raw:
	ld	a,(de)
	ld	hl,generic_console_flags
	res	6,(hl)
	and	a	
	jr	z,success
	set	6,(hl)
	jr	success

get_console_size:
	ld	hl,(generic_console_w)
	ex	de,hl		;hl = arg
	ld	(hl),e
	inc	hl
	ld	(hl),d
	jr	success
#endasm
}
