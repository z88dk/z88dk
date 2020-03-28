   ;;
   ;; find out if ram RAMTOP is low enough
   ;; to accommodate the extended binary
   ;;
   
   EXTERN __MAIN_head

   IFNDEF DOTX_RAMTOP
      defc DOTX_RAMTOP = __MAIN_head
   ENDIF

   ld hl,(__SYSVAR_RAMTOP)
   ld de,DOTX_RAMTOP
   
   xor a
   sbc hl,de
   
   ld hl,error_ramtop
   jp nc, error_crt

   ;;
   ;; attempt to load extended binary
   ;;

   ld a,'$'
   ld hl,esxdos_dtx_filename
   ld b,__ESXDOS_MODE_OPEN_EXIST | __ESXDOS_MODE_READ
   
   rst  __ESXDOS_SYSCALL
   defb __ESXDOS_SYS_F_OPEN

   jr c, error_esxdos_dtx

   push af                     ; save file handle

   EXTERN __MAIN_END_tail

   ld bc,__MAIN_END_tail - __MAIN_head
   ld hl,__MAIN_head

   rst  __ESXDOS_SYSCALL
   defb __ESXDOS_SYS_F_READ

   pop hl                      ; h = file handle
   push af
   
   ld a,h
   
   rst  __ESXDOS_SYSCALL
   defb __ESXDOS_SYS_F_CLOSE
   
   pop af
   jr nc, success_esxdos_dtx

error_esxdos_dtx:

   ld l,a
   ld h,0
   
   jp error_crt

error_ramtop:

   defm "M RAMTOP no good ("
   defb (DOTX_RAMTOP - 1) / 10000 % 10 + '0'
   defb (DOTX_RAMTOP - 1) / 1000 % 10 + '0'
   defb (DOTX_RAMTOP - 1)/ 100 % 10 + '0'
   defb (DOTX_RAMTOP - 1) / 10 % 10 + '0'
   defb (DOTX_RAMTOP - 1) % 10 + '0'
   defb ')'+0x80

esxdos_dtx_filename:

IF __NEXTOS_DOT_COMMAND

   defm __ENV_BINDIR, "/extra/"

ELSE

   defm "/bin/extra/"

ENDIF

PUBLIC __z_dtx_filename

__z_dtx_filename:

   defs 13                     ; filled in by appmake

success_esxdos_dtx:
