/*
 *	Package.h
 *
 *	Defns(!) for package DORS
 *
 *	djm 9/2/2000
 *
 *	$Id: package.h,v 1.5 2016-04-23 08:00:38 dom Exp $
 */

#ifdef MAKE_PACKAGE
typedef struct  {
	int (*fn)();
} package_str;


#define PKGNAME_MAC(b) defm b , 0

#pragma asm
	INCLUDE	"error.def"
	INCLUDE "packages.def"

; Some needed routines

; $00xx Package Info
.packg_inf
	ld	hl,pkg_name
	ld	a,($4D3)
	ld	b,a		;name of pkg in bhl
	ld	c,$01		;Version of handling reqd
	ld	de,PACK_VERSION
	and	a		;success
	ret
.pkg_name
	PKGNAME_MAC(PACK_NAME)

.packg_exp
#ifdef PACK_BOOT
	ld	a,b		;Check for autoboot
	cp	exp_boot	;Fc=0 if so, we want to autoboot
	ret	z
#endif
	ld	a,RC_Unk
	scf
	ret

; Other essential routines have to be done by the app itself

; Start the package DOR
.in_package_dor
	defb	PACKAGE_ID
#ifdef OLDPACK
	defm	"oZ"
#else
	defb	'P'
#endif
	defb	MAX_CALL_NUM
	defw	packg_inf		;Get information
	defw	_pack_ayt	;Are You There + Allocate
	defw	_pack_bye	;Bye..and deallocate
	defw	_pack_dat	;Return info abt resources
	defw	packg_exp	;Expansion
#pragma endasm
#endif

