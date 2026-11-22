INCLUDE "config_zxn_private.inc"

SECTION code_user

PUBLIC _load_bas
PUBLIC _load_dot
PUBLIC _load_snap
PUBLIC _load_nex

defc MAX_NAME_LEN = 12         ; 8.3 only

EXTERN _mode48
EXTERN _dirent_sfn
EXTERN _flags
EXTERN asm_puts, asm_exit

defc PROGRAM_NAME = _dirent_sfn + 1;

;;;;;;;;;;;;;;;;;;;;;
; void load_bas(void)
;;;;;;;;;;;;;;;;;;;;;

_load_bas:

   ; can't load in 48k mode
   
   ld a,(_mode48)
   
   or a
   ret nz
   
   ; can't load a bas from here so print message giving instructions
   
   ld de,bas_name
   call copy_filename
   
   ld a,'"'
   ld (de),a

   ld hl,bas_msg
   call asm_puts
   
   ; ensure that cwd is not returned to on exit

   ld a,(_flags)
   or 0x04                     ; option --cd
   ld (_flags),a
   
   ; exit without error
   
   ld hl,0
   jp asm_exit
   
bas_msg:

   defm "\nTo start - LOAD ", '"'

bas_name:

   defs MAX_NAME_LEN + 2

;;;;;;;;;;;;;;;;;;;;;
; void load_dot(void)
;;;;;;;;;;;;;;;;;;;;;

_load_dot:

   call close_dot_handle

   ld sp,(__SYSVAR_ERRSP)
   
   ld iy,__SYS_IY
   ld hl,__SYS_HLP
   exx

   ; make room for dot command name
   
   ld bc,dot_stub_end - dot_stub + MAX_NAME_LEN + 1
   
   rst __ESX_RST_ROM
   defw __ROM3_BC_SPACES

   push de                     ; save start address
   
   ; copy dot_stub
   
   ld hl,dot_stub
   ld bc,dot_stub_end - dot_stub
   
   ldir

   ; copy filename
   
   ld ix,dot_name - dot_stub_end
   add ix,de                   ; ix = address of dot name

   call copy_filename
   
   xor a
   ld (de),a

   ; start dot command
   
   pop hl                      ; hl = start address
   rst __ESX_RST_EXITDOT

dot_stub:

   push ix
   pop hl

   rst __ESX_RST_SYS
   defb __ESX_M_EXECCMD
   
   jr c, dot_stub_err
   
   rst 8
   defb __ERRB_0_OK - 1 

dot_stub_err:

   rst 8
   defb __ERRB_Q_PARAMETER_ERROR - 1

dot_name:

   defm "./"

dot_stub_end:

;;;;;;;;;;;;;;;;;;;;;;
; void load_snap(void)
;;;;;;;;;;;;;;;;;;;;;;

_load_snap:

   call unlock_7ffd
   call close_dot_handle

   ld sp,(__SYSVAR_ERRSP)
   ld iy,__SYS_IY
   
   ; in 48k mode make sure there is a valid stack for M_P3DOS
   
   ld a,(_mode48)
   
   or a
   jr z, skip48

   ld hl,__SYSVAR_TSTACK
   ld (__SYSVAR_OLDSP),hl
   
skip48:

   ; make room for snap stub
   
   ld bc,snap_stub_end - snap_stub + MAX_NAME_LEN + 1
   
   rst __ESX_RST_ROM
   defw __ROM3_BC_SPACES
   
   push de                     ; save start address
   
   ; copy snap_stub
   
   ld hl,snap_stub
   ld bc,snap_stub_end - snap_stub
   
   ldir
   
   push de                     ; save filename address
   
   ; copy filename
   
   call copy_filename
   
   ld a,0xff
   ld (de),a
   
   ; start the snap
   
   pop ix                      ; ix = filename

   pop hl                      ; hl = start address   
   rst __ESX_RST_EXITDOT

snap_stub:

   push ix
   pop hl
   
   exx
   
   ld de,__NEXTOS_IDE_SNAPLOAD
   ld c,7
   
   rst __ESX_RST_SYS
   defb __ESX_M_P3DOS

   ld bc,__IO_NEXTREG_REG
   ld a,__REG_PERIPHERAL_3
   out (c),a
   inc b
 
snap_p3_smc:

   ld a,0
   out (c),a

   ld iy,__SYS_IY
   ld hl,__SYS_HLP
   exx
   
   rst 8
   defb __ERRB_Q_PARAMETER_ERROR - 1

snap_stub_end:

;;;;;;;;;;;;;;;;;;;;;
; void load_nex(void)
;;;;;;;;;;;;;;;;;;;;;

_load_nex:

   call unlock_7ffd
   call close_dot_handle

   ld sp,(__SYSVAR_ERRSP)
   ld iy,__SYS_IY

   ; make room for nex stub

   ld bc,nex_stub_end - nex_stub + MAX_NAME_LEN + 1
   
   rst __ESX_RST_ROM
   defw __ROM3_BC_SPACES
   
   push de                     ; save start address
   
   ; copy snap_stub
   
   ld hl,nex_stub
   ld bc,nex_stub_end - nex_stub
   
   ldir

   ; copy filename
   
   ld ix,nex_stub_cmd - nex_stub_end
   add ix,de                   ; ix = address of dot command
   
   call copy_filename
   
   xor a
   ld (de),a

   ; start nex
   
   pop hl                      ; hl = start address
   rst __ESX_RST_EXITDOT

nex_stub:

   push ix
   pop hl
   
   rst __ESX_RST_SYS
   defb __ESX_M_EXECCMD
   
   ld bc,__IO_NEXTREG_REG
   ld a,__REG_PERIPHERAL_3
   out (c),a
   inc b
 
nex_p3_smc:

   ld a,0
   out (c),a

   ld iy,__SYS_IY
   ld hl,__SYS_HLP
   exx

   rst 8
   defb __ERRB_Q_PARAMETER_ERROR - 1

nex_stub_cmd:

   defm "nexload "

nex_stub_end:

;;;;;;;;;;;;;
; unlock 7ffd
;;;;;;;;;;;;;

; in 48k mode we will try to allow loading of 128k programs

unlock_7ffd:

   ld bc,__IO_NEXTREG_REG
   ld a,__REG_PERIPHERAL_3
   
   out (c),a
   
   inc b
   in a,(c)
   
   ld (snap_p3_smc + 1),a
   ld (nex_p3_smc + 1),a
   
   or __RP3_UNLOCK_7FFD
   out (c),a
   
   ret

;;;;;;;;;;;;;;;;;;
; close dot handle
;;;;;;;;;;;;;;;;;;

; exit via rst$20 does not close the dot handle

close_dot_handle:

   rst __ESX_RST_SYS
   defb __ESX_M_GETHANDLE
   
   rst __ESX_RST_SYS
   defb __ESX_F_CLOSE
   
   ret

;;;;;;;;;;;;;;;
; copy filename
;;;;;;;;;;;;;;;

copy_filename:

   ld hl,PROGRAM_NAME
   ld bc,MAX_NAME_LEN
   
   xor a
   
loop_name:

   cp (hl)
   ret z                       ; if terminator met
   
   ldi
   jp pe, loop_name            ; if max len not exceeded
   
   ret
