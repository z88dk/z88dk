SECTION PAGE_93_EnemyCode3
                            include "./Boulder2Roll.asm"
IF FAIL_TEST
defc SprData_StartPage = 50    ;;;;; AAAAAAAAAAAAAAAAAAAAAAAA
ENDIF

SECTION PAGE_50_spriteData_Enemies3

IF !FAIL_TEST
defc SprData_StartPage = 50     ;;;;; BBBBBBBBBBBBBBBBBBBBBBBB
ENDIF

public _Boulder2PalettePage

public _Boulder2PalettePage2
public _Boulder2PalettePage3
defc SprData_StartPage2 = 50
defs $4e00
defc _Boulder2PalettePage = SprData_StartPage+($ / $2000)   ;;;; CCCCCCCC
defc _Boulder2PalettePage2 = SprData_StartPage2+($ / $2000)
defc _Boulder2PalettePage3 = 50+($ / $2000)

public _Boulder2Palette
_Boulder2Palette:		defs 1000
_Boulder2Roll_DataPtr:	defs 2000
