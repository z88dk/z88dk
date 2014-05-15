
; ===============================================================
; May 2014
; ===============================================================
; 
; int _ioctl__unlocked(FILE *stream, uint16_t command, ...)
;
; IOCTL on FILEs.
; This is a temporary function until posix i/o is available.
;
; ===============================================================

INCLUDE "clib_cfg.asm"

PUBLIC asm__ioctl__unlocked

EXTERN asm__vioctl__unlocked, __stdio_varg_2, __stdio_nextarg_de

asm__ioctl__unlocked:

   ; MUST BE CALLED, NO JUMPS
   ;
   ; enter : none
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

   call __stdio_varg_2
   
   ld ixl,e
   ld ixh,d                    ; ix = FILE *
   
   call __stdio_nextarg_de     ; de = command
   
   ld c,l
   ld b,h                      ; bc = void *arg

   jp asm__vioctl__unlocked
