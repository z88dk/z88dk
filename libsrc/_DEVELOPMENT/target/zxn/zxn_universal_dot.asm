; Universal Dot Command
;
; Select dot command depending on whether
; the machine is in 48k or 128k mode.
;
; z80asm -b zxn_universal_dot.asm

INCLUDE "config_zxn_private.inc"

org 0x2000

zxn_universal_dot:

   jr start

;; Fixed position data filled in by appmake

__filename_dotx    :  defs 13
__filename_dotn    :  defs 13

;;

start:

   di
   
   ;; save command line
   
   push hl

   ;; copy trampoline to caller's stack
   
   ld hl,-1
   add hl,sp
   ex de,hl
   
   ld hl,trampoline_end - 1
   ld bc,trampoline_len
   
   lddr
   
   ex de,hl
   inc hl
   ld sp,hl
   
   push hl                     ; save &trampoline
   
   ;; verify that this is 128k NextOS mode
   ;; method provided by Garry Lancaster
   
   ld hl,(__SYSVAR_ERRSP)
   inc hl
   
   ld a,(hl)                   ; 48k mode if error routine is in lower 16k
   cp 0x40
   
   ld hl,__filename_dotn
   
   jr nc, mode_128k

mode_48k:

   ld hl,__filename_dotx

mode_128k:

   ; hl = filename

   ;; load dot binary
   
   push hl
   
   ld a,'$'
   ld b,__ESXDOS_MODE_OPEN_EXIST | __ESXDOS_MODE_READ
   
   rst  __ESXDOS_SYSCALL
   defb __ESXDOS_SYS_F_OPEN

   jr c, error_load_0
   
   push af                     ; save file handle
   
   ld hl,stat_s
   
   rst  __ESXDOS_SYSCALL
   defb __ESXDOS_SYS_F_FSTAT
   
   pop hl
   ld a,h                      ; file handle
   
   jr c, error_load_c
   
   pop de                      ; de = filename
   ld bc,(stat_s + stat_size)  ; bc = file size
   
   ld hl,error_load_1
   ex (sp),hl                  ; return address = error_load_1
   
   push de                     ; filename
   push af                     ; file handle
   push hl                     ; &trampoline
   
   ld hl,0x2000
   ret                         ; jump trampoline

error_load_c:

   rst  __ESXDOS_SYSCALL
   defb __ESXDOS_SYS_F_CLOSE

error_load_0:
   
   pop de                      ; filename
   pop bc                      ; trash &trampoline
   
error_load_1:

   ; write filename into error string

   ex de,hl
   ld de,error_load_s_name
   ld bc,12
   ldir
   
   ; restore caller's stack
   
   ld hl,trampoline_len + 2
   add hl,sp
   ld sp,hl

   ; terminate error message
   
   ld hl,error_load_s

   xor a
   cpir
   
   dec hl
   dec hl
   
   ld a,(hl)
   add a,0x80
   ld (hl),a
   
   ld hl,error_load_s
   
   ; if a==0 and carry is set, error message is pointed at by hl
   
   xor a
   scf
   
   ei
   ret

error_load_s:          defm "Can't load "
error_load_s_name:     defs 13

defvars 0
{
   stat_drive  ds.b 1
   stat_device ds.b 1
   stat_attr   ds.b 1
   stat_date   ds.w 2
   stat_size   ds.w 2
   SIZEOF_STAT
}

stat_s:                defs SIZEOF_STAT


;; TRAMPOLINE IN STACK

defc trampoline_len = trampoline_end - trampoline_begin

trampoline_begin:

   rst  __ESXDOS_SYSCALL
   defb __ESXDOS_SYS_F_READ
   
   pop hl
   push af
   
   ld a,h
   
   rst  __ESXDOS_SYSCALL
   defb __ESXDOS_SYS_F_CLOSE

   pop af
   pop de
   ret c                       ; if error loading
   
   ; interrupts are disabled
   
   ld hl,trampoline_len + 2
   add hl,sp
   ld sp,hl
   
   pop hl                      ; hl = command line
   jp 0x2000

trampoline_end:
