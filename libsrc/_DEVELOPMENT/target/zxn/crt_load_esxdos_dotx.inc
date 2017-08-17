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
   
   ld hl,(23730)               ; hl = RAMTOP
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
   
   ex de,hl                    ; hl = __DTX_head
   ld de,error_ramtop+18       ; de = & "00000"
   
   call l_utoa                 ; to ascii without leading zeroes
   
   ld a,')'+0x80
   ld (de),a                   ; terminate the string
   
   xor a
   scf

   ld hl,error_ramtop
   ret

error_ramtop:

   defm "M RAMTOP no good (00000)"

__esxdos_dtx_fname:

   defs 18                     ; filled in by appmake

ramtop_good:

   ;;
   ;; attempt to load extended binary
   ;;

   ld a,'$'
   ld hl,__esxdos_dtx_fname
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

   EXTERN __BSS_END_tail
   
   ld bc,__BSS_END_tail - __DTX_head
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
