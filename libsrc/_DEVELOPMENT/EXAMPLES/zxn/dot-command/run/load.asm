INCLUDE "config_zxn_private.inc"

SECTION code_user

PUBLIC _load_snap
PUBLIC _load_nex

EXTERN __sp_or_ret

defc MAX_NAME_LEN = 32

;;;;;;;;;;;;;;;;;;;;;;
; void load_snap(void)
;;;;;;;;;;;;;;;;;;;;;;

_load_snap:

   ld sp,(__sp_or_ret)

   ld hl,snap_stub - snap_stub_end - MAX_NAME_LEN - 1
   
   add hl,sp
   ld sp,hl
   
   push hl                     ; save exec address
   
   ex de,hl

   ld hl,snap_stub
   ld bc,snap_stub_end - snap_stub
   
   ldir

   push de
   pop ix                      ; ix = filename
   
   call stack_copy_name
   
   ld a,0xff
   ld (de),a                   ; terminate with 0xff

   pop hl                      ; hl = exec address
   rst 0x20

snap_stub:

   push ix
   pop hl
   
   exx
   
   ld de,__NEXTOS_IDE_SNAPLOAD
   ld c,7

   rst __ESX_RST_SYS
   defb __ESX_M_P3DOS
   
   rst 8
   defb __ERRB_Q_PARAMETER_ERROR - 1

snap_stub_end:

;;;;;;;;;;;;;;;;;;;;;
; void load_nex(void)
;;;;;;;;;;;;;;;;;;;;;

_load_nex:

   ld sp,(__sp_or_ret)

   ld hl,nex_stub - nex_stub_end - MAX_NAME_LEN - 1
   
   add hl,sp
   ld sp,hl
   
   push hl                     ; save exec address

   ex de,hl

   ld hl,nex_stub
   ld bc,nex_stub_cmd - nex_stub
   
   ldir
   
   push de
   pop ix                      ; ix = dot command
   
   ld bc,nex_stub_end - nex_stub_cmd
   
   ldir
   
   call stack_copy_name
   
   xor a
   ld (de),a                   ; zero terminate
   
   pop hl                      ; hl = exec address
   rst 0x20

nex_stub:

   push ix
   pop hl

   rst __ESX_RST_SYS
   defb __ESX_M_EXECCMD

   rst 8
   defb __ERRB_Q_PARAMETER_ERROR - 1

nex_stub_cmd:

   defm "bigload "

nex_stub_end:

;;;;;;;;;;;;;;;;;;;;;;;
; stack execution tools
;;;;;;;;;;;;;;;;;;;;;;;

EXTERN _program_name
EXTERN asm_basename

stack_copy_name:

   ; copy program name to max length
   ; without terminating zero
   
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
