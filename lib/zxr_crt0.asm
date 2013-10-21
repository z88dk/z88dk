;
; Startup for Residos packages
;
; $Id: zxr_crt0.asm,v 1.5 2013-10-21 14:23:44 stefano Exp $
;

        MODULE	zxs_crt0

        org     0

        INCLUDE	"zcc_opt.def"
	INCLUDE	"zxsysvar48.def"

; Define all the restarts to go to an appropriate routine
if (ASMPC<>$0000)
        defs    CODE_ALIGNMENT_ERROR
endif
restart0:
        jp      call_rom3
        
        defs    $0008-ASMPC
if (ASMPC<>$0008)
        defs    CODE_ALIGNMENT_ERROR
endif
restart8:
        ret
        
        defs    $0010-ASMPC
if (ASMPC<>$0010)
        defs    CODE_ALIGNMENT_ERROR
endif
restart16:
        ret
        
        defs    $0018-ASMPC
if (ASMPC<>$0018)
        defs    CODE_ALIGNMENT_ERROR
endif
restart24:
        ret
                            
        defs    $0020-ASMPC
if (ASMPC<>$0020)
        defs    CODE_ALIGNMENT_ERROR
endif
restart32:
        ret        
        
        defs    $0028-ASMPC
if (ASMPC<>$0028)
        defs    CODE_ALIGNMENT_ERROR
endif
restart40:
        ret
        
        defs    $0030-ASMPC
if (ASMPC<>$0030)
        defs    CODE_ALIGNMENT_ERROR
endif
restart48:
        ret        

; Always remember to provide an IM1 routine. It should update FRAMES as with
; the standard 48K ROM.

        defs    $0038-ASMPC

if (ASMPC<>$0038)
        defs    CODE_ALIGNMENT_ERROR
endif
im1routine:
        push    af
        push    hl
        ld      hl,(FRAMES)
        inc     hl
        ld      (FRAMES),hl
        ld      a,h
        or      l
        jr      nz,im1end
        ld      a,(FRAMES+2)
        inc     a
        ld      (FRAMES+2),a
im1end:
        pop     hl
        pop     af
        ei
        ret
    

; Always provide an NMI routine which performs a simple RETN.

        defs    $0066-ASMPC

if (ASMPC<>$0066)
        defs    CODE_ALIGNMENT_ERROR
endif
nmiroutine:
        retn


; Allow the calling of a ROM3 routine
call_rom3:
        ex      (sp),hl          ; get return address
        ld      c,(hl)
        inc     hl
        ld      b,(hl)           ; BC=BASIC address
        inc     hl
        ex      (sp),hl          ; restore return address
        push    bc
        pop     iy               ;iy=BASIC address, as needed by RESI_BASIC
        exx                      ; switch to alternates
        ld      b,PKG_RESIDOS    ; ResiDOS call
        ld      hl,RESI_BASIC    ; call BASIC
        jp      PACKAGE_CALL_PKG ; do the package call, then return

; Allow calling of +3 dos routines
dodos:
        exx
        ld      b,PKG_IDEDOS	 ; We want the IDEDOS package
        push    iy               ; Get the call into iy
        pop     hl
        ld      iy,23610        ; Restore IY
        jp      PACKAGE_CALL_PKG
        
l_dcal: jp      (hl)            ;Used for function pointer calls


;-----------
; Define the stdin/out/err area. For the z88 we have two models - the
; classic (kludgey) one and "ANSI" model
;-----------
__sgoioblk:
IF DEFINED_ANSIstdio
        INCLUDE "stdio_fp.asm"
ELSE
        defw    -11,-12,-10
ENDIF



;---------------------------------
; Select which printf core we want
;---------------------------------
_vfprintf:
IF DEFINED_floatstdio
        LIB     vfprintf_fp
        jp      vfprintf_fp
ELSE
        IF DEFINED_complexstdio
                LIB     vfprintf_comp
                jp      vfprintf_comp
        ELSE
                IF DEFINED_ministdio
                        LIB     vfprintf_mini
                        jp      vfprintf_mini
                ENDIF
        ENDIF
ENDIF

;-----------
; Now some variables
;-----------
coords:         defw    0       ; Current graphics xy coordinates
base_graphics:  defw    0       ; Address of the Graphics map

_std_seed:      defw    0       ; Seed for integer rand() routines

exitsp:         defw    0       ; Address of where the atexit() stack is
exitcount:      defb    0       ; How many routines on the atexit() stack

IF DEFINED_NEED1bitsound
snd_asave:      defb    0	; Sound variable
snd_tick:       defb    0	;  "      "
bit_irqstatus:	defw	0
ENDIF

                defm    "Small C+ ZXR"   ;Unnecessary file signature
                defb    0

;-----------------------
; Floating point support
;-----------------------
IF NEED_floatpack
	defs	FLOATING_POINT_NOT_SUPPORTED_FOR_RESIDOS_PACKAGES
        INCLUDE         "float.asm"
fp_seed:        defb    $80,$80,0,0,0,0 ;FP seed (unused ATM)
extra:          defs    6               ;FP register
fa:             defs    6               ;FP Accumulator
fasign:         defb    0               ;FP register

ENDIF


         

