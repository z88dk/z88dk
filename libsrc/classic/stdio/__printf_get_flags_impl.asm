
	MODULE	__printf_get_flags_impl
	SECTION code_clib
	PUBLIC	__printf_get_flags_impl

	EXTERN	__printf_set_flags
	EXTERN	__printf_set_width
	EXTERN	__printf_set_precision

	EXTERN	asm_atoi
	EXTERN	get_16bit_ap_parameter

__printf_get_flags_impl:
        ld      c,0
flags_again:
        push    hl              ;save fmt
        ld      b,5
        ld      hl,flags
flag_loop:
        cp      (hl)
        inc     hl
        jr      nz,no_flag
; We've found a flag
        ld      a,(hl)          ;pick up flags
        or      c
        ld      c,a
        pop     hl              ;get fmt back
        ld      a,(hl)          ;pick up next character
        inc     hl
        jr      flags_again
flags:
        defb    '-', 0x01
        defb    '+', 0x02
        defb    ' ', 0x08
        defb    '#', 0x10
        defb    '0', 0x04
no_flag:
        inc     hl
IF __CPU_GBZ80__
	dec     b
	jr      nz,flag_loop
ELSE
        djnz    flag_loop
ENDIF
        pop     hl
IF __CPU_INTEL__ | __CPU_GBZ80__
	call	__printf_set_flags
ELSE
        ld      (ix-4),c        ;save flags
ENDIF
check_width:
IF __CPU_INTEL__ | __CPU_GBZ80__
	push    de
	ld      de,0
	call	__printf_set_width
	pop     de
ELSE
        ld      (ix-5),0        ;default width=0
        ld      (ix-6),0
ENDIF
        cp      '*'
        jr      nz,check_width_from_format
starred_width:
        ; width comes from a parameter, later...
        push    hl      ;save format (points to '*'+1)
        call    get_16bit_ap_parameter  ;de=next ap pointer, hl=value
        ex      de,hl                   ;de=value, hl=ap
        ex      (sp),hl                 ;ap on stack, hl=fmt
        ;de = value, hl=format
        jr      save_width


check_width_from_format:
        ; hl = format
        ; de = ap
        cp      '0'
        jr      c,check_precision
        cp      '9'+1
        jr      nc,check_precision
        push    de              ;save ap
        dec     hl
        call    asm_atoi            ;exits hl=number, de=non numeric in fmt
                                ;TODO, check < 0
        ex      de,hl           ;hl=next format
save_width:
IF __CPU_INTEL__ | __CPU_GBZ80__
	call	__printf_set_width
ELSE
        ld      (ix-5),d        ;store width
        ld      (ix-6),e
ENDIF
        pop     de              ;get ap back
        ld      a,(hl)
        inc     hl
check_precision:
IF __CPU_INTEL__ | __CPU_GBZ80__
	push    de
	ld      de,-1
	call	__printf_set_precision
	pop     de
ELSE
        ld      (ix-7),255      ;precision = undefined
        ld      (ix-8),255
ENDIF
        cp      '.'
        jr      nz,no_precision
        ld      a,(hl)
        cp      '*'
        jr      nz,check_precision_from_format
        ; Precision comes from parameter
        inc     hl
        push    hl      ;save format
        call    get_16bit_ap_parameter  ;de=next ap pointer, hl=value
        ex      de,hl
        ex      (sp),hl
        ;de = value, hl=format
        jr      save_precision

check_precision_from_format:
        ;hl=format, de=ap
        push    de              ;save ap
        call    asm_atoi            ;exits hl=number, de=next arg
                                ;TODO, check <0
        ex      de,hl           ;hl=next format acharacter
save_precision:
IF __CPU_INTEL__ | __CPU_GBZ80__
	call	__printf_set_precision
ELSE
        ld      (ix-7),d
        ld      (ix-8),e
ENDIF
        ld      a,(hl)          ;next character
        inc     hl
        pop     de              ;restore ap
no_precision:
	ret
