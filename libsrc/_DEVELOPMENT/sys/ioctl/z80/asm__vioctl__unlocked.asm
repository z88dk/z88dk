
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
   ; uses  : af, bc, de, hl, ix

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
   
   ld a,(ix+13)
   push af                     ; save current driver flags
   
   xor e                       ; compare command driver type
   and $07
   jp nz, error_enotsup_mc - 1 ; if driver types do not match
   
   ld a,e                      ; check for load flags command
   or $07
   inc a                       ; z flag set if load

   ld a,(bc)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
IF __SDCC | __SDCC_IX | __SDCC_IY

   inc bc

ELSE

   dec bc

ENDIF
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

   ld d,a
   jr z, load_flags

boolean_flag:

   ld a,(bc)
   or d
   jr z, boolean_false
   
boolean_true:

   ld a,$f8                    ; all flag bits set

boolean_false:

   and e
   ld d,a                      ; d = bit state for affected flag bits
   
   ld a,e
   cpl
   and $f8
   or $07
   and (ix+13)                 ; zero affected flag bits
   
   jr exit

load_flags:

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
IF __SDCC | __SDCC_IX | __SDCC_IY

   ld a,(bc)                   ; MSB of integer parameter
   
   or a
   jp nz, error_einval_mc - 1  ; if load parameter larger than byte
   
   ld a,d                      ; LSB of integer parameter

ELSE

   or a
   jp nz, error_einval_mc - 1  ; if load parameter larger than byte
   
   ld a,(bc)                   ; LSB of integer parameter
   
ENDIF
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

   and $f8
   ld d,a
   ld a,e
   and $07

exit:

   or d                        ; or in new flag bits
   ld (ix+13),a                ; set new flag state
   
   pop hl
   ld l,h
   ld h,0                      ; hl = old flags
   
   ret
