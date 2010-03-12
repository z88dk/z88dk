/*
 *  Header for defining Residos Packages
 *
 *  $Id: package.h,v 1.2 2010-03-12 15:21:13 stefano Exp $
 */


#ifndef __RESIDOS_PACKAGE_H__
#define __RESIDOS_PACKAGE_H__


#ifdef MAKE_PACKAGE

#define PACKAGE_ADD(m)  static  void *package_## m= m

#define PACKAGE_END static char package_call_end = 0xff
    
#asm
        INCLUDE     "zxsysvar48.def"

; INSTALL has no entry parameters, and may corrupt any registers.
; Most packages simply return Fc=1 to indicate success. However, if your
; package needs extra resources (such as additional RAM banks) it may try
; to allocate them here. If it fails, after tidying up it should return
; Fc=0 and A=error code (such as A=brc_resi_noroom).

.Cpackage_install
#if PACKAGE_INSTALL_FUNC
        jp    PACKAGE_INSTALL_FUNC
#else
        scf                             ; package always succeeds
        ret
#endif

; BYE has no entry parameters, and may corrupt any registers.
; It should return Fc=1 to indicate it can safely be uninstalled.
; If some internal resources are in use by external programs, it should
; return Fc=0 and A=rc_resi_package_in_use.

.Cpackage_bye
#if PACKAGE_BYE_FUNC
        jp    PACKAGE_INSTALL_FUNC
#else
        scf                             ; package always succeeds
        ret
#endif

; INFO takes a reason code in A and returns package information appropriate,
; together with Fc=1 to indicate success.
; Unknown/unsupported reasons must return Fc=0 and A=rc_resi_unknown_reason.
; Reasons supported by this test package are:
;  info_version - return version number in BC (binary-coded decimal)
;  info_error   - store text for error B in the printer buffer (terminate
;                 with bit 7 set)

.Cpackage_info
        cp      info_version
        jr      z,package_getversion
#ifdef PACKAGE_ERROR_FUNCTION
        cp      info_error
        jr      nz,package_badreason
        ld      l,b                     ; error code is in B
        ld      h,0
        push    hl
        call    PACKAGE_ERROR_FUNC      
        pop     bc                      ; c = error code
        ld      a,h
        or      l
        jr      z, package_badreason  
        ld      de,PR_BUFF-1                      ; copy the error text to the printer buffer
        ex      de,hl
.package_error
        ld      a,(de)
        and     a
        jr      nz,package_error1
        set     7,(hl)                  ; Last character should toggle bit 7
        ld      a,c                     ; package code
        and     a                       ; Fc=0, Fz=0
        ret
.package_error1
        inc     hl
        inc     de
        ld      (hl),a
        jr      package_error
#endif
.package_badreason
        ld      a,rc_resi_unknown_reason        ; other reasons unknown
        and     a
        ret
.package_getversion
        ld      bc,PACKAGE_VERSION      ; version number
        scf                             ; success!
        ret
 
; EXP takes a reason code in A and performs appropriate actions.
; Unknown/unsupported reasons must return Fc=0 and A=rc_resi_unknown_reason.

.Cpackage_exp
        ld      a,rc_resi_unknown_reason
        and     a                       ; no reasons are handled
        ret


; The HOOK, CHANNELS, FS and NMI calls are used only for packages
; which register themselves with the appropriate capabilities.
; Packages not providing one or more of these calls should
; simply return Fc=0 and A=rc_resi_package_not_found.


; HOOK enters with H corrupted, L=hook code value. All other registers
; are as they were when the hook code was invoked, and so can be used
; as input parameters. All standard registers (including HL) and IX
; can be used as output parameters.
; It is probably good practice to use the convention of returning
; Fc=1 for success, or Fc=0 and A=error code. This is not required, though.
; None of them are implemented at the moment

.Cpackage_hook
.Cpackage_channels
.Cpackage_fs
.Cpackage_nmi
        ld      a,rc_resi_package_not_found
        and     a
        ret
.package_call_table
        defw    Cpackage_install
        defw    Cpackage_bye
        defw    Cpackage_info
        defw    Cpackage_exp
        defw    Cpackage_hook
        defw    Cpackage_channels
        defw    Cpackage_fs
        defw    Cpackage_nmi
        ; User code should use PACKAGE_ADD straight after this and end with PACKAGE_END
#endasm
#endif /* MAKE_PACKAGE */


#endif /* __RESIDOS_PACKAGE_H__ */
