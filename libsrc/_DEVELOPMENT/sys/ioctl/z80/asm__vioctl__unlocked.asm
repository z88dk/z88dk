
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

EXTERN l_jpix, STDIO_MSG_ICTL, __stdio_nextarg_bc
EXTERN error_einval_mc, error_enotsup_mc, error_mc

asm__vioctl__unlocked:

   ; enter : ix = FILE *
   ;         de = command
   ;         hl = void *stack_param = arg
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

   call __stdio_nextarg_bc     ; bc = first parameter

   ld a,e
   and $07
   jr z, forward_ioctl_1       ; if command type is not handled by stdio
   
   ; stdio handles so check for driver type match
   
   ld a,(ix+13)
   push af                     ; save driver flags state
   
   xor e
   and $07
   jp nz, error_enotsup_mc - 1 ; if driver types do not match
   
   inc d
   dec d
   jr nz, forward_ioctl_0      ; not a driver flags command
   
   ; forward ioctl to driver
   
   push bc
   push de
   
   call forward_ioctl_1        ; forward to driver
   
   pop de
   pop bc
   
   ; alter driver flags
   
   ld a,e
   or $07
   inc a
   jr z, load_flags            ; if load flags command
   
   ld a,b
   or c                        ; z flag set to true/false value of bc
   
   ld c,0                      ; false
   jr z, load_flags
   
   dec c                       ; true

load_flags:

   ld a,c
   and e
   ld c,a                      ; c = true/false state of affected bits
   
   ld a,e
   cpl
   and $f8
   or $07
   and (ix+13)                 ; clear flags bits that will be affected
   
   or c                        ; set state of affected bits
   ld (ix+13),a                ; write updated driver state flags
   
   pop hl                      ; h = old driver state flags
   
   ld l,h
   ld h,0
   
   ret

forward_ioctl_0:

   pop af

forward_ioctl_1:

   ld a,STDIO_MSG_ICTL
   call l_jpix

   ret nc   
   jp error_mc                 ; indicate error
