;       Small C+ Z88 stdlib functions
;
;       Provides for a routine to be executed on exit
;
;       18/10/98 djm
;       27/11/98 djm - allows upto 32 levels of exit routines
;
; -----
; $Id: atexit.asm,v 1.8 2016-03-06 22:03:07 dom Exp $

; int atexit((void *)(void))
; FASTCALL

SECTION code_clib
PUBLIC atexit
PUBLIC _atexit
EXTERN __clib_exit_stack_size
EXTERN exitsp, exitcount

; enter : hl = atexit function
; exit  : hl !=0 and no carry if can't register
;         hl  =0 and carry set if successful

.atexit
._atexit

   ex de,hl                  ; de = function to register

   ld hl,exitcount
   ld a,(hl)
   cp __clib_exit_stack_size  ; can only hold 32 levels..
   ret nc                    ; if full returns with hl!=0
   inc (hl)                  ; increment number of levels

   add a,a                   ; compute index in exit stack
   ld c,a
   ld b,0
IF __CPU_GBZ80__
   ld hl,exitsp
   ld a,(hl+)
   ld h,(hl)
   ld l,a
ELSE
   ld hl,(exitsp)
ENDIF
   add hl,bc
   ld (hl),e                 ; write atexit function
   inc hl
   ld (hl),d
   
   ld h,b
   ld l,b                    ; indicate success
   scf
   ret
