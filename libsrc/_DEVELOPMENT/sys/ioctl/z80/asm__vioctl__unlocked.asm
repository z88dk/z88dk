
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

EXTERN STDIO_MSG_ICTL
EXTERN l_jpix, __stdio_nextarg_bc
EXTERN error_einval_mc, error_enotsup_mc, error_mc

asm__vioctl__unlocked:

   ; enter : ix = FILE *
   ;         de = command
   ;            = xxxx xxxx xxxx x000 = forward to driver
   ;            = xxxx xxxx xxxx xDDD = if DDD does not match driver type, error
   ;            = 00xx xxxx xxxx xDDD = forward to driver
   ;            = 01xx xxxx xxxx xDDD = get flags (one bits in 13..3)
   ;            = 10xx xxxx xxxx xDDD = set flags (one bits in 13..3) using parameter
   ;            = 11xx xxxx xxxx xDDD = boolean flags (one bits in 13..3) using true/false parameter
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
   jr z, forward_ioctl         ; if command type is not handled by stdio
   
   ; stdio handles so check for driver type match
      
   ld a,(ix+13)
   xor e
   and $07
   jp nz, error_enotsup_mc     ; if driver types do not match
   
   ld a,d
   rlca
   rlca
   and $03                     ; a = 00 fwd, 01 getf, 10 setf, 11 bool
   jr z, forward_ioctl         ; if flag type is forward

   ; bc = parameter
   ; de = command
   ; hl = void *arg

   dec a
   jr z, __getf

   dec a
   jr z, __setf

__bool:

   ld a,b
   or c
   jr z, __setf
   
   ld bc,$ffff

__setf:

   ; bc = parameter
   ; de = command
   ; hl = void *arg

   push bc
   push de
   
   call forward_ioctl          ; forward to driver
   
   pop de
   pop bc

   ld l,(ix+13)
   ld h,(ix+14)                ; hl = driver flags
   
   ld a,d
   and $3f
   ld d,a                      ; will not affect bits 15..14
   
   ld a,e
   and $f8
   ld e,a                      ; will not affect bits 2..0   

   and c
   ld c,a
   ld a,d
   and b
   ld b,a                      ; bc = bc & de = final value of affected bits
   
   ld a,e
   cpl
   and l
   or c
   ld (ix+13),a
   
   ld a,d
   cpl
   and h
   or b
   ld (ix+14),a                ; write new value of driver flags
   
   ret

__getf:

   ; de = command

   ld a,e
   and $f8
   and (ix+13)
   ld l,a
   
   ld a,d
   and $3f
   and (ix+14)
   ld h,a
   
   ret

forward_ioctl:

   ld a,STDIO_MSG_ICTL
   call l_jpix

   ret nc   
   jp error_mc                 ; indicate error
