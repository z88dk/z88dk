;defc SprData_StartPage = 10
SECTION PAGE_93_EnemyCode3
							;include "./CaptainSquareJawData/Projectiles/Boulder/build/BoulderRoll.asm"
                            include "./BoulderRoll.asm"
defc SprData_StartPage = 10
SECTION PAGE_50_spriteData_Enemies3

public _BoulderPalettePage

public _BoulderPalettePage2
public _BoulderPalettePage3
defc SprData_StartPage2 = 50
defs $4e00
defc _BoulderPalettePage = SprData_StartPage+($ / $2000)
defc _BoulderPalettePage2 = SprData_StartPage2+($ / $2000)
defc _BoulderPalettePage3 = 50+($ / $2000)

;;defc _BoulderPalettePage = SprData_StartPage+($ / $2000)
;defc _BoulderPalettePage = 50+($ / $2000)
public _BoulderPalette
_BoulderPalette:		defs 1000	;binary "./CaptainSquareJawData/Projectiles/Boulder/build/Boulder.pal"

_BoulderRoll_DataPtr:	defs 2000	;binary "./CaptainSquareJawData/Projectiles/Boulder/build/BoulderRoll.spr1"

;defc SprData_StartPage = 10
