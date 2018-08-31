INCLUDE "config_zxn_private.inc"

SECTION code_user

PUBLIC _load_snap
PUBLIC _load_nex

defc MAX_NAME_LEN = 48

;;;;;;;;;;;;;;;;;;;;;;
; void load_snap(void)
;;;;;;;;;;;;;;;;;;;;;;

_load_snap:

   ld sp,(__SYSVAR_ERRSP)

   call close_dot_handle

   ; place reclaim_stub on stack
   ; addr of reclaim_stub left on stack
   
   call stack_reclaim_stub
   
   ; make room for snap_stub underneath PROG

   ld hl,(__SYSVAR_PROG)
   ld bc,snap_stub_end - snap_stub + MAX_NAME_LEN + 1
   
   push bc

   rst __ESX_RST_ROM
   defw __ROM3_MAKE_ROOM       ; insert space before hl

   inc hl                      ; point at space

   pop bc
   pop de
   
   push bc                     ; save space size for reclaim_stub
   push hl                     ; save space addr for reclaim_stub
   
   push hl                     ; save exec address
   push de                     ; save addr of reclaim_stub

   ; copy snap_stub except two bytes for jp destination

   ex de,hl

   ld hl,snap_stub
   ld bc,snap_stub_end - snap_stub - 2
   
   ldir

   ; write address of reclaim_stub into jp
   
   pop hl                      ; hl = addr of reclaim_stub
   
   ex de,hl

   ld (hl),e
   inc hl
   ld (hl),d
   inc hl
   
   ex de,hl
   
   ; copy filename
   
   push de
   pop ix                      ; ix = filename
   
   call stack_copy_name
   
   ld a,0xff
   ld (de),a                   ; terminate with 0xff

   pop hl                      ; hl = exec address
   rst __ESX_RST_EXITDOT

   ; must be below PROG not in stack

snap_stub:

   push ix
   pop hl
   
   exx
   
   ld de,__NEXTOS_IDE_SNAPLOAD
   ld c,7

   rst __ESX_RST_SYS
   defb __ESX_M_P3DOS
   
   jp 0                        ; jump to reclaim_stub

snap_stub_end:

;;;;;;;;;;;;;;;;;;;;;
; void load_nex(void)
;;;;;;;;;;;;;;;;;;;;;

_load_nex:

   ld sp,(__SYSVAR_ERRSP)

   call close_dot_handle

   ; place reclaim_stub on stack
   ; addr of reclaim_stub left on stack
   
   call stack_reclaim_stub
   
   ; make room for nex_stub underneath PROG

   ld hl,(__SYSVAR_PROG)
   ld bc,nex_stub_end - nex_stub + MAX_NAME_LEN + 1
   
   push bc

   rst __ESX_RST_ROM
   defw __ROM3_MAKE_ROOM       ; insert space before hl

   inc hl                      ; point at space

   pop bc
   pop de
   
   push bc                     ; save space size for reclaim_stub
   push hl                     ; save space addr for reclaim_stub
   
   push hl                     ; save exec address
   push de                     ; save addr of reclaim_stub

   ; copy nex_stub except two bytes for jp destination

   ex de,hl

   ld hl,nex_stub
   ld bc,nex_stub_cmd - nex_stub - 2
   
   ldir

   ; write address of reclaim_stub into jp
   
   pop hl                      ; hl = addr of reclaim_stub
   
   ex de,hl

   ld (hl),e
   inc hl
   ld (hl),d
   inc hl
   
   ex de,hl

   ; copy dot command

   push de
   pop ix                      ; ix = dot command
   
   ld hl,nex_stub_cmd
   ld bc,nex_stub_end - nex_stub_cmd
   
   ldir

   ; copy filename

   call stack_copy_name
   
   xor a
   ld (de),a                   ; zero terminate
   
   pop hl                      ; hl = exec address
   rst __ESX_RST_EXITDOT

   ; must be below PROG not in stack

nex_stub:

   push ix
   pop hl

   rst __ESX_RST_SYS
   defb __ESX_M_EXECCMD

   jp 0                        ; jump to reclaim_stub

nex_stub_cmd:

   defm "nexload "

nex_stub_end:

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

;;;;;;;;;;;;;;;;;;;;;;;
; stack execution tools
;;;;;;;;;;;;;;;;;;;;;;;

EXTERN _program_name
EXTERN asm_basename

; copy program name to max length without terminating zero

stack_copy_name:

   push de                     ; save destination
   
   ld hl,_program_name
   call asm_basename
   
   pop de
   
   ld bc,MAX_NAME_LEN
   
   xor a
   
loop_name:

   cp (hl)
   ret z                       ; if terminator met
   
   ldi
   jp pe, loop_name            ; if max len not exceeded
   
   ret

; copy reclaim_stub code to stack
; leave address of reclaim_stub on stack

stack_reclaim_stub:

   pop ix

   ld hl,reclaim_stub - reclaim_stub_end

   add hl,sp
   ld sp,hl
   
   push hl                     ; save address of reclaim_stub
   
   ex de,hl
   
   ld hl,reclaim_stub
   ld bc,reclaim_stub_end - reclaim_stub
   
   ldir
   
   jp (ix)

reclaim_stub:

   pop hl                      ; space addr
   pop bc                      ; space size
   
   call __ROM3_RECLAIM_2       ; release reserved memory
   
   rst 8
   defb __ERRB_Q_PARAMETER_ERROR - 1

reclaim_stub_end:
