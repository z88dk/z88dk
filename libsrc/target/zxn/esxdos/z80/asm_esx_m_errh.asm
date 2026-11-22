; void esx_m_errh(void (*handler)(uint8_t error))

INCLUDE "config_private.inc"

SECTION code_esxdos

PUBLIC asm_esx_m_errh

EXTERN _esx_errh
EXTERN l_inc_sp

asm_esx_m_errh:

   ; dot command rom3 error intercept
   ;
   ; registers an error handler jumped to on error
   ; if the error handler resumes, an attempt will be made to resume the program
   ;
   ; enter : hl = void (*handler)(uint8_t error)
   ;
   ; exit  : hl = old error handler
   ;
   ; uses  : af, bc, de, hl, ix
   
   ld de,(_esx_errh)
   ld (_esx_errh),hl         ; store address of error handler
   
   ld a,h
   or l
   jr z, register_handler      ; if 0, restoring default handler
   
   ld hl,intercept

register_handler:
   
   push de
   
IF __SDCC_IY
   push hl
   pop iy
ELSE
   push hl
   pop ix
ENDIF

   rst __ESX_RST_SYS
   defb __ESX_M_ERRH
   
   pop hl
   ret

intercept:

   ; when an error occurs, come here first
   
   push de                     ; save return address

   ; push error handler parameter "uint8_t error"

IF __SDCC
   ld e,a
   ld d,a
   push de
   inc sp
ENDIF

IF __SCCZ80
   ld e,a
   ld d,0
   push de
ENDIF

   ; return address if user error handler returns and wants to resume
   ; if return simply clear the stack of pushed parameter and then return
   
IF __SDCC
   ld hl,l_inc_sp - 1
   push hl
ENDIF

IF __SCCZ80
   ld hl,l_inc_sp - 2
   push hl
ENDIF
   
   ld hl,(_esx_errh)
   push hl
   
   ex de,hl                    ; l = uint8_t error
   ret                         ; call user error handler


; ***************************************************************************
; * M_ERRH ($95) *
; ***************************************************************************
; Install error handler for dot command.
; Entry: HL=address of error handler within dot command
; (0 to change back to standard handler)
;
; NOTES:
; Can only be used from within a dot command.
; If any BASIC error occurs during a call to ROM3 (using RST $10 or RST $18)
; then your error handler will be entered with:
; DE=address that would have been returned to if the error had not
; occurred
; A=BASIC error code-1 (eg 8=9 STOP statement)
