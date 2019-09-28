

	MODULE	mode


	SECTION	code_driver
	PUBLIC	mode
	PUBLIC	_mode
	PUBLIC	get_mode
	PUBLIC	_get_mode
	PUBLIC	__mode

	EXTERN	MODE_TABLE

; void __LIB__ mode(uint8_t m) NONBANKED;
mode:
_mode:
        ld      hl,sp+2         ; Skip return address
        ld      l,(hl)
        ld      h,0x00
        call    set_mode
        ret

; uint8_t __LIB__ get_mode(void) NONBANKED;
get_mode:
_get_mode:
        ld      hl,__mode
        ld      e,(hl)
        ld      l,a
        ld      h,0
        ret


set_mode:
        ld      a,l
        ld      (__mode),a

        ;; AND to get rid of the extra flags
        and     0x03
        ld      l,a
        ld      bc,MODE_TABLE
        sla     l               ; Multiply mode by 4
        sla     l
        add     hl,bc
        jp      (hl)            ; Jump to initialization routine


	SECTION	bss_driver

__mode:	defb	0		;Current screen mode


