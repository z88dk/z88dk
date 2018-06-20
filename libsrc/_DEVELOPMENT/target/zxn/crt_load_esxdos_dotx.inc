   ;;
   ;; save command line if used
   ;;

IF __crt_enable_commandline >= 2

   push hl

ENDIF

   ;;
   ;; find out if ram RAMTOP is low enough
   ;; to accommodate the extended binary
   ;;
   
   EXTERN __DTX_head
   
   ld hl,(__SYSVAR_RAMTOP)
   ld de,__DTX_head
   
   xor a
   sbc hl,de
   
   jr c, ramtop_good

ramtop_bad:

IF __crt_enable_commandline >= 2

   pop hl

ENDIF

   ;;
   ;; print error message
   ;;
   
   EXTERN l_utoa
   
   ex de,hl
   dec hl                      ; hl = __DTX_head - 1

   ld de,error_ramtop_address  ; de = & "00000"

   scf
   call l_utoa                 ; to ascii with leading zeroes
   
   xor a
   scf

   ld hl,error_ramtop
   ret

error_ramtop:

   defm "M RAMTOP no good ("

error_ramtop_address:

   defm "00000"
   defb ')'+0x80

esxdos_dtx_filename:

   defm "__ENV_BINDIR"         ; from config_target.m4

__z_dtx_filename:

   defs 13                     ; filled in by appmake

ramtop_good:

   ;;
   ;; attempt to load extended binary
   ;;

   ld a,'$'
   ld hl,esxdos_dtx_filename
   ld b,__ESXDOS_MODE_OPEN_EXIST | __ESXDOS_MODE_READ
   
   rst  __ESXDOS_SYSCALL
   defb __ESXDOS_SYS_F_OPEN

IF __crt_enable_commandline >= 2

   EXTERN l_ret
   jp c,  l_ret - 1

ELSE
   
   ret c
   
ENDIF

   push af                     ; save file handle

   EXTERN __DTX_END_tail

   ld bc,__DTX_END_tail - __DTX_head
   ld hl,__DTX_head

   rst  __ESXDOS_SYSCALL
   defb __ESXDOS_SYS_F_READ

   pop hl                      ; h = file handle
   push af
   
   ld a,h
   
   rst  __ESXDOS_SYSCALL
   defb __ESXDOS_SYS_F_CLOSE
   
   pop af
   
IF __crt_enable_commandline >= 2

   pop hl

ENDIF

   ret c
