/*
 *      Header file which will build the application DOR and all
 *      that gubbins, most of it is already predefined, so you
 *      may want to create your own hacked up version of this
 *      if you need a special configuration
 *
 *      The default application type is AT_BAD|AT_DRAW and a default
 *      of 8k required page
 *
 *      This file is somewhat bizarre in that we include it after
 *      we define something - these defines are given to use via
 *      including the file dor.h
 *
 *      You should supply all the variables defined in the #ifndef
 *      clauses below, if not, you'll end up with the defaults!
 *
 *      7/4/99 djm Commands and topics now supported -see command?.h
 *      for details on these brutes...it ain't fun!!
 *
 *	Packages are now supported (work for 16k packages)
 *
 *	$Id: application.h,v 1.4 2009-06-22 21:33:57 dom Exp $
 */

#ifndef HELP1
        #define HELP1 "An application made with the z88dk"
        #define HELP2 "For more information on the z88dk"
        #define HELP3 "See http://www.z88dk.org"
#endif

#ifndef HELP2
        #define HELP2 ""
#endif

#ifndef HELP3
        #define HELP3 ""
#endif

#ifndef HELP4
        #define HELP4 ""
#endif

#ifndef HELP5
        #define HELP5 ""
#endif

#ifndef HELP6
        #define HELP6 ""
#endif


#ifndef APP_INFO
        #define APP_INFO "Made by z88dk"
#endif

#ifndef APP_NAME
        #define APP_NAME "z88dkapp"
#endif

#ifndef APP_KEY
        #define APP_KEY 'A'
#endif

#ifndef APP_TYPE
        #define APP_TYPE AT_Def
#endif

#ifndef APP_TYPE2
        #define APP_TYPE2 AT2_Cl
#endif


/*
 * Some macros which do our generation for us
 */

#define APPLBYTE(b)     defb    b

#define APPLNAME(b)     defm    b &0

#define HELPTEXT(b)     defm    b &127

#define APPLTEXT(b)     defm    b



#pragma asm
; Here we go, with lots of assembler!
        INCLUDE "dor.def"
        INCLUDE "zcc_opt.def"   ; The universal saviour file!

        XREF    app_entrypoint  ; The real starting point for our apps
        XDEF    applname        ; So startup can pick it up
        XDEF    in_dor
        XDEF    in_dor_seg_setup
	XDEF	in_dor_seg0
	XDEF	in_dor_seg1
	XDEF	in_dor_seg2
	XDEF	in_dor_seg3

; How much bad memory do we actually need
; If reqpag is defined already do nothing, else default to $20 pages
        IF ( reqpag = 0 ) | reqpag
        ELSE
                defc    reqpag = $20
        ENDIF

;Safe workspace needed by app (user specifies so can have app using
;static vars that is still good...) be careful though!
        IF !safedata
                defc    safedata = 0
        ENDIF

.dummy_entry
        jp      app_entrypoint
IF ( (reqpag=0) | (reqpag >= 32) )
        scf            ; no bad or >8k bad needed
        ret
ELSE
        ld      bc,8192+(reqpag*256)

        ld      de,8192+8192
        or      a
        ret
ENDIF


; Initally let us consider only single bank applications

        defc    in_bank = 63

; Application DOR

.in_dor defb    0,0,0   ; links to parent, brother, son
        defb    0,0,0	; brother
/* Packages use the son DOR link */
#ifdef MAKE_PACKAGE
	defw	in_package_dor
	defb	in_bank
#else
        defw    0       ;brother_add
        defb    0       ;brother_bank
#endif
        defb    $83     ; DOR type - application
        defb    indorend-indorstart
.indorstart     
        defb    '@'     ; key to info section
        defb    ininfend-ininfstart
.ininfstart     
        defw    0
        APPLBYTE(APP_KEY)
IF reqpag = 0
        defb    0
ELSE 
        IF reqpag <=32
                defb    32
        ELSE
                defb    reqpag  ; contigious RAM
        ENDIF
ENDIF
        defw    0       ; overhead
        defw    0       ; unsafe workspace
        defw    55+safedata ; safe workspace (used for startup vars)
                            ; and user specifed safe data
        defw    dummy_entry   ; entry point
; These are set up by appmake, but we can define top for certain
.in_dor_seg_setup
.in_dor_seg0
        defb    0       ; segment bindings
.in_dor_seg1
        defb    0
.in_dor_seg2
        defb    0
.in_dor_seg3
        defb    in_bank
        APPLBYTE(APP_TYPE)      ; at_bad etc
        APPLBYTE(APP_TYPE2)     ;caps lock
.ininfend       defb    'H'     ; key to help section
        defb    inhlpend-inhlpstart
.inhlpstart     defw    in_topics
        defb    in_bank
        defw    in_commands
        defb    in_bank
        defw    in_help
        defb    in_bank
        defb    0,0,0   ; no tokens
.inhlpend       defb    'N'     ; key to name section
        defb    innamend-innamstart
.innamstart     
        APPLNAME(APP_NAME)
.innamend       defb    $ff
.indorend

; topics, shoved in header file to make this one more readable!

.in_topics      defb    0

#include <oz/command0.h>

; end marker for end of topics

.incom_topend
        defb    0

/*
 *      Command entries, to keep the file smaller, included
 */

.in_commands    defb    0

#include        <oz/command1.h>
#include        <oz/command2.h>
#include        <oz/command3.h>
#include        <oz/command4.h>
#include        <oz/command5.h>
#include        <oz/command6.h>
#include        <oz/command7.h>


.in_coms_end    defb    0       ;end marker


; Help entries

.in_help        defb    $7f
        HELPTEXT(HELP1)
        HELPTEXT(HELP2)
        HELPTEXT(HELP3)
        HELPTEXT(HELP4)
        HELPTEXT(HELP5)
        HELPTEXT(HELP6)
        defb    0
/*
 * Help files for commands and topics, help0.h is for topics, rest are for
 * commands for topic n - we assume that there isn't more than 8k of em, if
 * there is then the whole DOR collapses!
 */
#include <oz/help0.h>
#include <oz/help1.h>
#include <oz/help2.h>
#include <oz/help3.h>
#include <oz/help4.h>
#include <oz/help5.h>
#include <oz/help6.h>
#include <oz/help7.h>
.applname
        APPLNAME(APP_INFO)
#pragma endasm



