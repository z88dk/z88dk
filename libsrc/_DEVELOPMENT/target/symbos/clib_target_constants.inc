
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; target library constants ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

   ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
   ;; symbos defines
   ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

   ;@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
   ;@                                                                            @
   ;@                    S y m b O S   -   C o n s t a n t s                     @
   ;@                                                                            @
   ;@             (c) 2000-2008 by Prodatron / SymbiosiS (Jörn Mika)             @
   ;@                                                                            @
   ;@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@


   ;P R O C E S S - I D S
   
   PUBLIC __PRC_ID_KERNEL, __PRC_ID_DESKTOP, __PRC_ID_SYSTEM
   
   defc __PRC_ID_KERNEL   = 1   ;kernel process
   defc __PRC_ID_DESKTOP  = 2   ;desktop manager process
   defc __PRC_ID_SYSTEM   = 3   ;system manager process


   ;M E S S A G E S
   ;General

   PUBLIC __MSC_GEN_QUIT, __MSC_GEN_FOCUS

   defc __MSC_GEN_QUIT    = 0   ;application is beeing asked, to quit itself
   defc __MSC_GEN_FOCUS   = 255 ;application is beeing asked, to focus its window

   ;Kernel Commands

   PUBLIC __MSC_KRL_MTADDP, __MSC_KRL_MTDELP, __MSC_KRL_MTADDT
   PUBLIC __MSC_KRL_MTDELT, __MSC_KRL_MTSLPP, __MSC_KRL_MTWAKP
   PUBLIC __MSC_KRL_TMADDT, __MSC_KRL_TMDELT, __MSC_KRL_TMDELP

   defc __MSC_KRL_MTADDP  = 1   ;add process (P1/2=stack, P3=priority (7 high - 1 low), P4=ram bank (0-8))
   defc __MSC_KRL_MTDELP  = 2   ;delete process (P1=ID)
   defc __MSC_KRL_MTADDT  = 3   ;add timer (P1/2=stack, P4=ram bank (0-8))
   defc __MSC_KRL_MTDELT  = 4   ;delete timer (P1=ID)
   defc __MSC_KRL_MTSLPP  = 5   ;set process to sleep mode
   defc __MSC_KRL_MTWAKP  = 6   ;wake up process
   defc __MSC_KRL_TMADDT  = 7   ;add counter service (P1/2=address, P3=ram bank, P4=process, P5=fr=ency)
   defc __MSC_KRL_TMDELT  = 8   ;delete counter service (P1/2=address, P3=ram bank)
   defc __MSC_KRL_TMDELP  = 9   ;delete all counter services of one process (P1=process ID)

   ;Kernel Responses

   PUBLIC __MSR_KRL_MTADDP, __MSR_KRL_MTDELP, __MSR_KRL_MTADDT
   PUBLIC __MSR_KRL_MTDELT, __MSR_KRL_MTSLPP, __MSR_KRL_MTWAKP
   PUBLIC __MSR_KRL_TMADDT, __MSR_KRL_TMDELT, __MSR_KRL_TMDELP

   defc __MSR_KRL_MTADDP  = 129 ;process has been added (P1= /1->ok/failed, P2=ID)
   defc __MSR_KRL_MTDELP  = 130 ;process has been deleted
   defc __MSR_KRL_MTADDT  = 131 ;timer process has been deleted (P1= /1->ok/failed, P2=ID)
   defc __MSR_KRL_MTDELT  = 132 ;timer has been removed
   defc __MSR_KRL_MTSLPP  = 133 ;process is sleeping now
   defc __MSR_KRL_MTWAKP  = 134 ;process has been waked up
   defc __MSR_KRL_TMADDT  = 135 ;counter service has been added (P1= /1->ok/failed)
   defc __MSR_KRL_TMDELT  = 136 ;counter service has been deleted
   defc __MSR_KRL_TMDELP  = 137 ;all counter services of a process have been deleted

   ;System Commands

   PUBLIC __MSC_SYS_PRGRUN, __MSC_SYS_PRGEND, __MSC_SYS_SYSWNX
   PUBLIC __MSC_SYS_SYSWPR, __MSC_SYS_PRGSTA, __MSC_SYS_SYSSEC
   PUBLIC __MSC_SYS_SYSQIT, __MSC_SYS_SYSOFF, __MSC_SYS_PRGSET
   PUBLIC __MSC_SYS_PRGTSK, __MSC_SYS_SYSFIL, __MSC_SYS_SYSHLP
   PUBLIC __MSC_SYS_SYSCFG, __MSC_SYS_SYSWRN, __MSC_SYS_PRGSRV
   PUBLIC __MSC_SYS_SELOPN

   defc __MSC_SYS_PRGRUN  = 16  ;load application or document (P1/2=address filename, P3=ram bank filename)
   defc __MSC_SYS_PRGEND  = 17  ;quit application (P1=ID)
   defc __MSC_SYS_SYSWNX  = 18  ;open dialogue to change current window (next) (-)
   defc __MSC_SYS_SYSWPR  = 19  ;open dialogue to change current window (previouse) (vorheriges) (-)
   defc __MSC_SYS_PRGSTA  = 20  ;open dialogue to load application or document (-)
   defc __MSC_SYS_SYSSEC  = 21  ;open system secuity dialogue (-)
   defc __MSC_SYS_SYSQIT  = 22  ;open shut shown dialogue (-)
   defc __MSC_SYS_SYSOFF  = 23  ;shut down (-)
   defc __MSC_SYS_PRGSET  = 24  ;start control panel (P1=submodul ->=main window, 1=display settings, 2=date/time)
   defc __MSC_SYS_PRGTSK  = 25  ;start taskmanager (-)
   defc __MSC_SYS_SYSFIL  = 26  ;call filemanager function (P1=number, P2-13=AF,BC,DE,HL,IX,IY)
   defc __MSC_SYS_SYSHLP  = 27  ;start help (-)
   defc __MSC_SYS_SYSCFG  = 28  ;call config function (P1=number,=load, 1=save, 2=reload background)
   defc __MSC_SYS_SYSWRN  = 29  ;open message/confirm window (P1/2=adresse, P3=ram bank, P4=number of buttons)
   defc __MSC_SYS_PRGSRV  = 30  ;shared service function (P4=type [0=search, 1=start, 2=release], P1/2=addresse 12char ID, P3=ram bank 12char ID or P3=program ID, if type=2)
   defc __MSC_SYS_SELOPN  = 31  ;open fileselect dialogue (P6=filename ram bank, P8/9=filename address, P7=forbidden attributes, P10=max entries, P12=max buffer size)

   ;System Responses

   PUBLIC __MSR_SYS_PRGRUN, __MSR_SYS_SYSFIL, __MSR_SYS_SYSWRN
   PUBLIC __MSR_SYS_PRGSRV, __MSR_SYS_SELOPN

   defc __MSR_SYS_PRGRUN  = 144 ;application has been started (P1=result ->=ok, 1=file doesnt exist, 2=file is not executable, 3=error while loading  [P8=filemanager error code], 4=memory full, P8=app ID, P9=process ID)
   defc __MSR_SYS_SYSFIL  = 154 ;filemanager function returned (P1=number, P2-13=AF,BC,DE,HL,IX,IY)
   defc __MSR_SYS_SYSWRN  = 157 ;message/confirm window response (P1 ->=already in use, 1=opened [P2=number], 2=ok, 3=yes, 4=no, 5=cancel/close)
   defc __MSR_SYS_PRGSRV  = 158 ;shared service function response (P1=state [5=not found, other codes see MSR_SYS_PRGRUN], P8=app ID, P9=process ID)
   defc __MSR_SYS_SELOPN  = 159 ;message from fileselect dialogue (P1 ->=Ok, 1=cancel, 2=already in use, 3=no memory free, 4=no window free, -1=open ok, modal window has been opened [P2=number])

   ;Desktop Commands

   PUBLIC __MSC_DSK_WINOPN, __MSC_DSK_WINMEN, __MSC_DSK_WININH
   PUBLIC __MSC_DSK_WINTOL, __MSC_DSK_WINTIT, __MSC_DSK_WINSTA
   PUBLIC __MSC_DSK_WINMVX, __MSC_DSK_WINMVY, __MSC_DSK_WINTOP
   PUBLIC __MSC_DSK_WINMAX, __MSC_DSK_WINMIN, __MSC_DSK_WINMID
   PUBLIC __MSC_DSK_WINMOV, __MSC_DSK_WINSIZ, __MSC_DSK_WINCLS
   PUBLIC __MSC_DSK_WINDIN, __MSC_DSK_DSKSRV, __MSC_DSK_WINSLD
   PUBLIC __MSC_DSK_WINPIN, __MSC_DSK_WINSIN

   defc __MSC_DSK_WINOPN  = 32  ;open window (P1=ram bank, P2/3=address data record)
   defc __MSC_DSK_WINMEN  = 33  ;redraw menu bar (P1=window ID) [only if focus]
   defc __MSC_DSK_WININH  = 34  ;redraw window content (P1=window ID, P2=-1/-Num/Object, P3=Object) [only if focus]
   defc __MSC_DSK_WINTOL  = 35  ;redraw window toolbar (P1=window ID) [only if focus]
   defc __MSC_DSK_WINTIT  = 36  ;redraw window title (P1=window ID) [only if focus]
   defc __MSC_DSK_WINSTA  = 37  ;redraw window status lien (P1=window ID) [only if focus]
   defc __MSC_DSK_WINMVX  = 38  ;set content x offset (P1=window ID, P2/3=XPos) [only if focus]
   defc __MSC_DSK_WINMVY  = 39  ;set content y offset (P1=window ID, P2/3=XPos) [only if focus]
   defc __MSC_DSK_WINTOP  = 40  ;takes window to the front (P1=window ID) [always]
   defc __MSC_DSK_WINMAX  = 41  ;maximize window (P1=window ID) [always]
   defc __MSC_DSK_WINMIN  = 42  ;minimize window (P1=window ID) [always]
   defc __MSC_DSK_WINMID  = 43  ;restore window size (P1=window ID) [always]
   defc __MSC_DSK_WINMOV  = 44  ;moves window to a new position (P1=window ID, P2/3=XPos, P4/5=YPos) [always]
   defc __MSC_DSK_WINSIZ  = 45  ;resize the window (P1=window ID, P2/3=XPos, P4/5=YPos) [always]
   defc __MSC_DSK_WINCLS  = 46  ;closes and removes window (P1=window ID) [always]
   defc __MSC_DSK_WINDIN  = 47  ;redraw window content, even if it hasnt focus (P1=window ID, P2=-1/-Num/Objekt, P3=Object) [always]
   defc __MSC_DSK_DSKSRV  = 48  ;desktop service r=est (P1=type, P2-P5=parameters)
   defc __MSC_DSK_WINSLD  = 49  ;redraw window scrollbars (P1=window ID) [only if focus]
   defc __MSC_DSK_WINPIN  = 50  ;redraw window content part (P1=window ID, P2=-1/-Num/Object, P3=Object, P4/5=Xbeg, P6/7=Ybeg, P8/9=Xlen, P10/11=Ylen) [always]
   defc __MSC_DSK_WINSIN  = 51  ;redraw content of a super control (P1=window ID, P2=super control ID, P3=SubObject) [always]

   ;Desktop Responses

   PUBLIC __MSR_DSK_WOPNER, __MSR_DSK_WOPNOK, __MSR_DSK_WCLICK
   PUBLIC __MSR_DSK_DSKSRV, __MSR_DSK_WFOCUS, __MSR_DSK_CFOCUS
   PUBLIC __MSR_DSK_WRESIZ, __MSR_DSK_WSCROL

   defc __MSR_DSK_WOPNER  = 160 ;open window failed; the maximum of 32 windows has been reached
   defc __MSR_DSK_WOPNOK  = 161 ;open window successfull (P4=number)
   defc __MSR_DSK_WCLICK  = 162 ;window has been clicked (P1=window number, P2=action, P3=subspezification, P4/5,P6/7,P8/9=parameters)
   defc __MSR_DSK_DSKSRV  = 163 ;desktop service answer (P1=type, P2-P5=parameters)
   defc __MSR_DSK_WFOCUS  = 164 ;window got/lost focus (P1=window number, P2=type [0=blur, 1=focus])
   defc __MSR_DSK_CFOCUS  = 165 ;control focus changed (P1=window number, P2=control number, P3=reason [0=mouse click/wheel, 1=tab key])
   defc __MSR_DSK_WRESIZ  = 166 ;window has been resized (P1=window number)
   defc __MSR_DSK_WSCROL  = 167 ;window content has been scrolled (P1=window number)

   ;Shell Commands

   PUBLIC __MSC_SHL_CHRINP, __MSC_SHL_STRINP, __MSC_SHL_CHROUT
   PUBLIC __MSC_SHL_STROUT, __MSC_SHL_EXIT

   defc __MSC_SHL_CHRINP  = 64  ;char is requested (P1=channel [0=standard, 1=keyboard])
   defc __MSC_SHL_STRINP  = 65  ;line is requested (P1=channel [0=standard, 1=keyboard], P2=ram bank, P3/4=address)
   defc __MSC_SHL_CHROUT  = 66  ;char should be writtten (P1=channel [0=standard, 1=screen], P2=char)
   defc __MSC_SHL_STROUT  = 67  ;line should be writtten (P1=channel [0=standard, 1=screen], P2=ram bank, P3/4=address, P5=length)
   defc __MSC_SHL_EXIT    = 68  ;application released focus or quit itself (P1 ->=quit, 1=blur)

   ;Shell Responses

   PUBLIC __MSR_SHL_CHRINP, __MSR_SHL_STRINP, __MSR_SHL_CHROUT
   PUBLIC __MSR_SHL_STROUT

   defc __MSR_SHL_CHRINP  = 192 ;char has been received (P1=EOF-flag [0=no EOF], P2=char, P3=error status)
   defc __MSR_SHL_STRINP  = 193 ;line has been received (P1=EOF-flag [0=no EOF], P3=error status)
   defc __MSR_SHL_CHROUT  = 194 ;char has been written (P3=error status)
   defc __MSR_SHL_STROUT  = 195 ;line has been written (P3=error status)

   ;Screensaver Messages

   PUBLIC __MSC_SAV_INIT, __MSC_SAV_START, __MSC_SAV_CONFIG
   PUBLIC __MSR_SAV_CONFIG

   defc __MSC_SAV_INIT    = 1   ;initialises the screen saver (P1=bank of config data, P2/3=address of config data [64bytes])
   defc __MSC_SAV_START   = 2   ;start screen saver
   defc __MSC_SAV_CONFIG  = 3   ;open screen savers own config window (at the end the screen saver has to send the result back to the sender)
   defc __MSR_SAV_CONFIG  = 4   ;returns user adjusted screen saver config data (P1=bank of config data, P2/3=address of config data [64bytes])


   ;D E S K T O P - A C T I O N S

   PUBLIC __DSK_ACT_CLOSE, __DSK_ACT_MENU, __DSK_ACT_CONTENT
   PUBLIC __DSK_ACT_TOOLBAR, __DSK_ACT_KEY

   defc __DSK_ACT_CLOSE   = 5   ;close button has been clicked or ALT+F4 has been pressed
   defc __DSK_ACT_MENU    = 6   ;menu entry has been clicked (P8/9=menu entry value)
   defc __DSK_ACT_CONTENT = 14  ;a control of the content has been clicked (P3=sub spec [see dsk_sub...], P4=key or P4/5=Xpos within the window, P6/7=Ypos, P8/9=control value)
   defc __DSK_ACT_TOOLBAR = 15  ;a control of the toolbar has been clicked (see DSK_ACT_CONTENT)
   defc __DSK_ACT_KEY     = 16  ;key has been pressed without touching/modifying a control (P4=Ascii Code)

   PUBLIC __DSK_SUB_MLCLICK, __DSK_SUB_MRCLICK, __DSK_SUB_MDCLICK
   PUBLIC __DSK_SUB_MMCLICK, __DSK_SUB_KEY, __DSK_SUB_MWHEEL

   defc __DSK_SUB_MLCLICK = 0   ;left mouse button has been clicked
   defc __DSK_SUB_MRCLICK = 1   ;right mouse button has been clicked
   defc __DSK_SUB_MDCLICK = 2   ;double click with the left mouse button
   defc __DSK_SUB_MMCLICK = 3   ;middle mouse button has been clicked
   defc __DSK_SUB_KEY     = 7   ;keyboard has been clicked and did modify/click a control (P4=Ascii Code)
   defc __DSK_SUB_MWHEEL  = 8   ;mouse wheel has been moved (P4=Offset)


   ;D E S K T O P - S E R V I C E S

   PUBLIC __DSK_SRV_MODGET, __DSK_SRV_MODSET, __DSK_SRV_COLGET
   PUBLIC __DSK_SRV_COLSET, __DSK_SRV_DSKSTP, __DSK_SRV_DSKCNT
   PUBLIC __DSK_SRV_DSKPNT, __DSK_SRV_DSKBGR, __DSK_SRV_DSKPLT

   defc __DSK_SRV_MODGET  = 1   ;get screen mode (output P2=mode, P3=virtual desktop)
   defc __DSK_SRV_MODSET  = 2   ;set screen mode (input P2=mode, P3=virtual desktop)
   defc __DSK_SRV_COLGET  = 3   ;get colour      (input P2=number, output P2=number, P3/4=RGB value)
   defc __DSK_SRV_COLSET  = 4   ;set colour      (input P2=number, P3/4=RGB value)
   defc __DSK_SRV_DSKSTP  = 5   ;freeze desktop  (input P2=type [0=Pen0, 1=Raster, 2=background, 255=no screen modification, switch off mouse])
   defc __DSK_SRV_DSKCNT  = 6   ;continue desktop
   defc __DSK_SRV_DSKPNT  = 7   ;clear desktop   (Eingabe P2=Typ [0=Pen0, 1=Raster, 2=background])
   defc __DSK_SRV_DSKBGR  = 8   ;initialize and redraw desktop background
   defc __DSK_SRV_DSKPLT  = 9   ;redraw the complete desktop


   ;J U M P S

   PUBLIC __jmp_memsum, __jmp_sysinf, __jmp_clcnum
   PUBLIC __jmp_mtgcnt, __jmp_timget, __jmp_timset
   PUBLIC __jmp_memget, __jmp_memfre, __jmp_memsiz
   PUBLIC __jmp_meminf, __jmp_bnkrwd, __jmp_bnkwwd
   PUBLIC __jmp_bnkrbt, __jmp_bnkwbt, __jmp_bnkcop
   PUBLIC __jmp_bnkget

   defc __jmp_memsum  = $8100 ;MEMSUM
   defc __jmp_sysinf  = $8103 ;SYSINF
   defc __jmp_clcnum  = $8106 ;CLCNUM
   defc __jmp_mtgcnt  = $8109 ;MTGCNT
   defc __jmp_timget  = $810C ;TIMGET
   defc __jmp_timset  = $810F ;TIMSET
   defc __jmp_memget  = $8118 ;MEMGET
   defc __jmp_memfre  = $811B ;MEMFRE
   defc __jmp_memsiz  = $811E ;MEMSIZ
   defc __jmp_meminf  = $8121 ;MEMINF
   defc __jmp_bnkrwd  = $8124 ;BNKRWD
   defc __jmp_bnkwwd  = $8127 ;BNKWWD
   defc __jmp_bnkrbt  = $812A ;BNKRBT
   defc __jmp_bnkwbt  = $812D ;BNKWBT
   defc __jmp_bnkcop  = $8130 ;BNKCOP
   defc __jmp_bnkget  = $8133 ;BNKGET
                      ;**empty**

   PUBLIC __jmp_scrget, __jmp_mosget, __jmp_moskey
   PUBLIC __jmp_bnk16c, __jmp_keytst, __jmp_keysta
   PUBLIC __jmp_keyput, __jmp_bufput, __jmp_bufget
   PUBLIC __jmp_bufsta, __jmp_iominp, __jmp_iomout
   
   defc __jmp_scrget  = $8139 ;SCRGET
   defc __jmp_mosget  = $813C ;MOSGET
   defc __jmp_moskey  = $813F ;MOSKEY
   defc __jmp_bnk16c  = $8142 ;BNK16C
   defc __jmp_keytst  = $8145 ;KEYTST
   defc __jmp_keysta  = $8148 ;KEYSTA
   defc __jmp_keyput  = $814B ;KEYPUT
   defc __jmp_bufput  = $814E ;BUFPUT
   defc __jmp_bufget  = $8151 ;BUFGET
   defc __jmp_bufsta  = $8154 ;BUFSTA
   defc __jmp_iominp  = $8157 ;IOMINP (cpc only)
   defc __jmp_iomout  = $815a ;IOMOUT (cpc only)

   PUBLIC __jmp_bnkcll, __jmp_bnkret

   defc __jmp_bnkcll  = $ff03 ;BNKCLL
   defc __jmp_bnkret  = $ff00 ;BNKRET


   ;Filemanager Functions (call via MSC_SYS_SYSFIL)

   PUBLIC __FNC_FIL_STOINI, __FNC_FIL_STONEW, __FNC_FIL_STORLD
   PUBLIC __FNC_FIL_STODEL, __FNC_FIL_STOINP, __FNC_FIL_STOOUT
   PUBLIC __FNC_FIL_STOACT, __FNC_FIL_STOINF, __FNC_FIL_STOTRN

   defc __FNC_FIL_STOINI  = 0
   defc __FNC_FIL_STONEW  = 1
   defc __FNC_FIL_STORLD  = 2
   defc __FNC_FIL_STODEL  = 3
   defc __FNC_FIL_STOINP  = 4
   defc __FNC_FIL_STOOUT  = 5
   defc __FNC_FIL_STOACT  = 6
   defc __FNC_FIL_STOINF  = 7
   defc __FNC_FIL_STOTRN  = 8

   PUBLIC __FNC_FIL_DEVDIR, __FNC_FIL_DEVINI, __FNC_FIL_DEVSET

   defc __FNC_FIL_DEVDIR  = 13
   defc __FNC_FIL_DEVINI  = 14
   defc __FNC_FIL_DEVSET  = 15

   PUBLIC __FNC_FIL_FILINI, __FNC_FIL_FILNEW, __FNC_FIL_FILOPN
   PUBLIC __FNC_FIL_FILCLO, __FNC_FIL_FILINP, __FNC_FIL_FILOUT
   PUBLIC __FNC_FIL_FILPOI, __FNC_FIL_FILF2T, __FNC_FIL_FILT2F
   PUBLIC __FNC_FIL_FILLIN

   defc __FNC_FIL_FILINI  = 16
   defc __FNC_FIL_FILNEW  = 17
   defc __FNC_FIL_FILOPN  = 18
   defc __FNC_FIL_FILCLO  = 19
   defc __FNC_FIL_FILINP  = 20
   defc __FNC_FIL_FILOUT  = 21
   defc __FNC_FIL_FILPOI  = 22
   defc __FNC_FIL_FILF2T  = 23
   defc __FNC_FIL_FILT2F  = 24
   defc __FNC_FIL_FILLIN  = 25

   PUBLIC __FNC_FIL_DIRDEV, __FNC_FIL_DIRPTH, __FNC_FIL_DIRPRS
   PUBLIC __FNC_FIL_DIRPRR, __FNC_FIL_DIRREN, __FNC_FIL_DIRNEW
   PUBLIC __FNC_FIL_DIRINP, __FNC_FIL_DIRDEL, __FNC_FIL_DIRRMD
   PUBLIC __FNC_FIL_DIRMOV, __FNC_FIL_DIRINF

   defc __FNC_FIL_DIRDEV  = 32
   defc __FNC_FIL_DIRPTH  = 33
   defc __FNC_FIL_DIRPRS  = 34
   defc __FNC_FIL_DIRPRR  = 35
   defc __FNC_FIL_DIRREN  = 36
   defc __FNC_FIL_DIRNEW  = 37
   defc __FNC_FIL_DIRINP  = 38
   defc __FNC_FIL_DIRDEL  = 39
   defc __FNC_FIL_DIRRMD  = 40
   defc __FNC_FIL_DIRMOV  = 41
   defc __FNC_FIL_DIRINF  = 42

   ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
   ;; target error
   ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
   
   ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
   ;; target messages
   ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

   ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
   ;; target ioctls
   ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;      
   
;; end target library constants ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
