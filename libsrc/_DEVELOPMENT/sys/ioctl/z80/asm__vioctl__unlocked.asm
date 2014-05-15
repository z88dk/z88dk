
; ===============================================================
; May 2014
; ===============================================================
; 
; int _vioctl__unlocked(FILE *stream, uint16_t command, void *arg)
;
; IOCTL on FILEs.
; This is a temporary function until posix i/o is available.
;
; ===============================================================

INCLUDE "clib_cfg.asm"

PUBLIC asm__vioctl__unlocked
PUBLIC asm0__vioctl__unlocked

EXTERN error_einval_mc, error_enotsup_mc

asm__vioctl__unlocked:

   ; enter : ix = FILE *
   ;         de = command
   ;         bc = void *stack_param = arg
   ;
   ; exit  : ix = FILE *
   ;
   ;         success
   ;
   ;            hl = return value != -1
   ;            carry reset
   ;
   ;         fail
   ;
   ;            hl = -1
   ;            carry set, errno set
   ;
   ; uses  : af, bc, de, hl

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
IF __CLIB_OPT_STDIO & $01

   EXTERN __stdio_verify_valid

   call __stdio_verify_valid
   ret c

ENDIF
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

asm0__vioctl__unlocked:

   inc d
   dec d
   jp nz, error_einval_mc      ; if command not understood
   
   ld a,(ix+13)                ; driver flags
   xor e
   and $07                     ; compare command driver type
   jp nz, error_enotsup_mc     ; if driver types do not match
   
   ; kind of parameter
   
   ld a,e
   or $07
   inc a

   ld a,(bc)

IF __SDCC | __SDCC_IX | __SDCC_IY

   inc bc

ELSE

   dec bc

ENDIF
   
   ld d,a
   jr z, load_parameter

boolean_parameter:

   ld a,(bc)
   or d
   jr z, have_boolean
   
   ld a,$f8

have_boolean:

   and e
   ld d,a
   
   ld a,e
   cpl
   and $f8
   or $07
   and (ix+13)
   
   or d
   ld (ix+13),a
   
   ret

load_parameter:

IF __SDCC | __SDCC_IX | __SDCC_IY

   ld a,(bc)
   or a
   jp nz, error_einval_mc      ; if load parameter larger than byte
   ld a,d

ELSE

   or a
   ld a,(bc)
   jp nz, error_einval_mc
   
ENDIF

   and $f8
   ld d,a
   ld a,e
   and $07
   or d
   ld (ix+13),a
   
   ret
