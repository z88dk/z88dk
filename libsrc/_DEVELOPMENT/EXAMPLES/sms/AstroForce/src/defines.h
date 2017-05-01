#include "bank2.h"
#include "bank3.h"
#include "bank4.h"
#include "bank5.h"
#include "bank6.h"
#include "bank7.h"
#include "bank8.h"
#include "bank9.h"
#include "bank10.h"
#include "bank11.h"
#include "bank12.h"
#include "bank13.h"
#include "bank14.h"
#include "bank15.h"

// For debug only
#define NO_PLAYERINMUNE

// Player shoot speeds
#define SPEEDPLAYERSHOOT_NORMAL 10
#define SPEEDPLAYERSHOOT_SIDE 7
#define SPEEDPLAYERSHOOT_SIDE_VERTICAL 3

// Default enemy shoot speed
#define DEFAULTENEMYSHOOTSPEED 5
#define DEFAULTENEMYSHOOTLASERSPEED 7

typedef struct enemy
{
	unsigned char enemyposx;
	unsigned char enemyposy;
	unsigned char enemytype;
	unsigned char enemyframe;
	unsigned char enemyparama;
	unsigned char enemyparamb;
	unsigned char enemyenergy;
	unsigned char enemywidth;
	unsigned char enemyheight;
}enemy;
typedef void (*MyInitEnemyFunction)( enemy *);
typedef unsigned char (*MyUpdateEnemyFunction)( enemy *);
typedef void (*MyKillEnemyFunction)(void);
typedef unsigned char (*MyCheckCollisionFunction)( unsigned char, unsigned char);

// Sound bank
#define SOUNDBANK 2

//////////////////////////////////////////////////////////
// SCRIPTING
#define SCRIPT_ADVANCESCROLLER 1
#define SCRIPT_INITENEMY 2
#define SCRIPT_SETPALETTE 3
#define SCRIPT_FILLBACKGROUND 4
#define SCRIPT_KILLENEMIES 5
#define SCRIPT_LOOP 6
#define SCRIPT_SETEXPLOSION 7
#define SCRIPT_END 8
#define SCRIPT_INITSCRIPT 9
#define SCRIPT_SETLABEL 10


//////////////////////////////////////////////////////////
// ENEMIES

// Warning!
#define WARNING 1

// Objects of intro and finish
#define INTROOVNILEFT 2
#define INTROOVNIRIGHT 3
#define INTROSIDEPLAYER 4
#define INTROSTAR 5

// Stage 4 enemies
#define WAVESHIP 6
#define RECTSHIP 7
#define TURNSHIP 8
#define BOMBSHIPLEFT 9
#define BOMBSHIPRIGHT 10
#define SPREADSHIP 11

// Stage 4 bosses
#define STAGE4MIDDLEBOSS 12
#define STAGE4ENDBOSS 13

// Stage 5 enemies
#define WW2ZEPPELIN 14
#define WW2SHIP 15
#define WW2PLANE_TYPE_A 16
#define WW2PLANE_TYPE_B 17
#define WW2PLANE_TYPE_C 18
#define WW2PLANE_TYPE_D 19
#define WW2PLANE_TYPE_E 20
#define WW2PLANE_TYPE_F 21
#define WW2TANKLEFT 22
#define WW2TANKRIGHT 23

// Stage 5 boss
#define STAGE5ENDBOSS 24

// Intro 3 object
#define INTRO3OBJECT 25

// Stage 7 enemies
#define MONSTERBLOB 26
#define MONSTERHEAD 27
#define MONSTERMISSILLEFT 28
#define MONSTERMISSILRIGHT 29

// Stage 7 boss
#define STAGE7MIDDLEBOSS 30
#define STAGE7ENDBOSS 31

// Stage 7 object
#define STAGE7OBJECT 32

// Stage 1 enemies
#define FORTRESSSEARCHER 33
#define FORTRESSDOOR 34
#define FORTRESSWAVE 35
#define FORTRESSPHANTOM 36
#define FORTRESSCANNONLEFT 37
#define FORTRESSCANNONRIGHT 38

// Stage 1 bosses
#define STAGE1MIDDLEBOSS 39
#define STAGE1ENDBOSS 40

// Stage 4 delayer
#define STAGE4OBJECT 41

// Stage 2 enemies
#define VULCANSTATION 42
#define VULCANVULCAN 43
#define VULCANBIRD 44
#define VULCANLASER 45
#define VULCANLAVA 46
#define VULCANTANKLEFT 47
#define VULCANTANKRIGHT 48
#define VULCANTANKSTOP 49

// Stage 2 boss
#define STAGE2ENDBOSS 50

// Stage 2 delayer
#define STAGE2OBJECT 51

// Stage 3 enemies
#define SPACEASTEROIDBIG 52
#define SPACEASTEROIDMEDIUM 53
#define SPACEASTEROIDLITTLE 54
#define SPACESTATION 55
#define SPACESHOOTER 56

// Stage 3 boss
#define STAGE3ENDBOSS 57

// Stage 6 boss
#define STAGE6ENDBOSS 58
#define SKULLBONEA 59
#define SKULLBONEB 60
#define SKULLBONEC 61

// Bosses elements
#define STAGE5MISSILE 62
#define STAGE7ENDBOSSB 63
#define STAGE4ENDBOSSB 64
#define STAGE4ENDBOSSC 65
#define STAGE3ENDBOSSB 66

#define STAGE3LASERUP 67
#define STAGE3LASERUPRIGHT 68
#define STAGE3LASERRIGHT 69
#define STAGE3LASERDOWNRIGHT 70
#define STAGE3LASERDOWN 71
#define STAGE3LASERDOWNLEFT 72
#define STAGE3LASERLEFT 73
#define STAGE3LASERUPLEFT 74

#define STAGE1MIDDLEBOSSB 75
#define STAGE1MIDDLEBOSSC 76
#define STAGE6ENDBOSSB 77
#define STAGE6OBJECT 78

#define STAGE8BOSSA 79
#define STAGE8BOSSB 80
#define STAGE8BOSSC 81
#define STAGE8SHOOTER 82
#define RSGTHING 83

#define WW2PLANEB 84
#define STAGE8LATERAL 85

//////////////////////////////////////////////////////////
// WW2PLANE SPEEDS AND DIRECTIONS

#define WW2PLANE_SPEED 4
#define WW2PLANE_SPEED_HALF 3

#define WW2PLANE_DIR_UP 0
#define WW2PLANE_DIR_LEFT 1
#define WW2PLANE_DIR_RIGHT 2
#define WW2PLANE_DIR_DOWN 3
#define WW2PLANE_DIR_DOWNRIGHT 4
#define WW2PLANE_DIR_DOWNLEFT 5
#define WW2PLANE_DIR_UPLEFT 6
#define WW2PLANE_DIR_UPRIGHT 7
#define WW2PLANE_END 8

//////////////////////////////////////////////////////////
// SPRITES

// Intro and ending
#define INTROOVNIBASE 310
#define INTROSIDEPLAYERBASE 310
#define INTROSTARBASE 314

// Jukebox
#define CURSORSBASE 256

// Player
#define PLAYERBASE 256
#define PLAYERINDICATORBASE 270
#define PLAYERSHOOTBASE 272

// Powerup
#define POWERUPBASE 276

// Explosions
#define SHOOTEXPLOSIONBASE 270+12
#define LITTLEEXPLOSIONBASE 270+12
#define BIGEXPLOSIONBASE 273+12

// Enemy shoots
#define ENEMYSHOOTBASE 297+12

// Warning
#define WARNINGBASE 301+12

// Enemies at Stage 4
#define RECTSHIPBASE 315+12
#define BOMBSHIPBASE 321+12
#define SPREADSHIPBASE 333+12
#define TURNSHIPBASE 349+12
#define WAVESHIPBASE 361+12

// Stage 4 bosses
#define STAGE4MIDDLEBOSSBASE 373+12
#define STAGE4ENDBOSSBASE 398+12
#define STAGE4ENDBOSSBASEC 416+12
#define STAGE4ENDBOSSBASEB 434+12

// Enemies at Stage 2
#define WW2PLANEBASE 315+12
#define WW2TANKBASE 355+12
#define WW2ZEPPELINBASE 371+12
#define WW2SHIPBASE 379+12

// Stage 2 boss
#define STAGE5ENDBOSSBASE 383+12
#define STAGE5MISSILEBASE 418+12
#define STAGE5MISSILEBASEB 419+12

// Stage 2 cloud
#define STAGE5CLOUDBASE 383+12+40

// Enemies at stage 7
#define MONSTERBLOBBASE 315+12
#define MONSTERHEADBASE 327+12
#define MONSTERMISSILBASE 354+12

// Stage 7 bosses
#define STAGE7ENDBOSSBASE 370+12
#define STAGE7MIDDLEBOSSBASE 383+12  

// Stage 1 enemies
#define FORTRESSSEARCHERBASE 315+12
#define FORTRESSDOORBASE 339+12
#define FORTRESSWAVEBASE 343+12
#define FORTRESSPHANTOMBASE 347+12
#define FORTRESSCANNONBASE 363+12

// Stage 1 bosses
#define STAGE1MIDDLEBOSSBASE 379+12
#define STAGE1ENDBOSSBASE 404+12

// Stage 2 enemies
#define VULCANVULCANBASE 315+12
#define VULCANLAVABASE 319+12
#define VULCANBIRDBASE 323+12
#define VULCANLASERBASE 347+12
#define VULCANTANKBASE 355+12
#define VULCANSTATIONBASE 375+12

// Stage 2 bosses
#define STAGE2ENDBOSSBASE 395+12

// Stage 2 enemies
#define SPACEASTEROIDBIGBASE 373+12
#define SPACEASTEROIDMEDIUMBASE 382+12
#define SPACEASTEROIDLITTLEBASE 386+12
#define SPACESTATIONBASE 387+12
#define STAGE3STARBASE 396+12
#define SPACESHOOTERBASE 398+12

// Stage 3 bosses
#define STAGE3ENDBOSSBASE 410+12

// Stage 6 boss
#define STAGE6ENDBOSSBASE 353+12
#define SKULLBONEBASE 353+35+12

// Stage 8 bosses
#define STAGE8SHOOTERBASE 398+12
#define STAGE8BOSSBBASE 447-128
#define STAGE8BOSSCBASE 410+12
#define STAGE8LATERALBASE 410+12+16

