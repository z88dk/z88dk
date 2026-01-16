// Data bank
#define FIXEDBANKSLOT 15

extern signed char playershootspeedsx[];
extern signed char playershootspeedsy[];

extern const unsigned char selectorstatebasetiles[];
extern const unsigned char *selectornamestage[];
extern const unsigned char selectormarkx[];
extern const unsigned char selectormarky[];
extern const unsigned char selectormarkt[];

extern const unsigned char sinustable[];
extern const char *jukebox_songs[];
extern const unsigned char jukebox_repeat[];
extern const char jukebox_banks[];
extern const unsigned char *jukebox_names[];

extern const signed char ww2planemovementy[];
extern const signed char ww2planemovementx[];
extern const unsigned char ww2plane_pattern_a[];
extern const unsigned char ww2plane_pattern_b[];
extern const unsigned char ww2plane_pattern_c[];
extern const unsigned char ww2plane_pattern_d[];
extern const unsigned char ww2plane_pattern_e[];
extern const unsigned char ww2plane_pattern_f[];
extern const unsigned char *ww2plane_patterns[];

#define intro1script_bank FIXEDBANKSLOT
extern const unsigned char intro1script[];
extern const unsigned char *intro1labels[];

#define intro4script_bank FIXEDBANKSLOT
extern const unsigned char intro4script[];

#define intro2script_bank FIXEDBANKSLOT
extern const unsigned char intro2script[];

#define intro3script_bank FIXEDBANKSLOT
extern const unsigned char intro3script[];
extern const unsigned char *intro3labels[];


#define finishscript_bank  FIXEDBANKSLOT
extern const unsigned char finishscript[];
extern const unsigned char *finishlabels[];

extern const unsigned char stagedatamarks[];
extern const unsigned char *stageinitdata[];

#define stage4script_bank  FIXEDBANKSLOT
extern const unsigned char stage4script[];

#define stage4scriptb_bank  FIXEDBANKSLOT
extern const unsigned char stage4scriptb[];

#define stage4scriptc_bank  FIXEDBANKSLOT
extern const unsigned char stage4scriptc[];

#define stage5script_bank  FIXEDBANKSLOT
extern const unsigned char stage5script[];

#define stage5scriptb_bank  FIXEDBANKSLOT
extern const unsigned char stage5scriptb[];

#define stage5scriptc_bank  FIXEDBANKSLOT
extern const unsigned char stage5scriptc[];

#define spawners_bank  FIXEDBANKSLOT
extern const const unsigned char *spawners[];

#define stage5_statics_bank  FIXEDBANKSLOT
extern const unsigned int stage5_statics[];

#define stage8_statics_bank  FIXEDBANKSLOT
extern const unsigned int stage8_statics[];

#define stage1_statics_bank  FIXEDBANKSLOT
extern const unsigned int stage1_statics[];

#define stage2_statics_bank  FIXEDBANKSLOT
extern const unsigned int stage2_statics[];

#define stage6script_bank  FIXEDBANKSLOT
extern const unsigned char stage6script[];

#define stage6scriptb_bank  FIXEDBANKSLOT
extern const unsigned char stage6scriptb[];

#define stage3script_bank  FIXEDBANKSLOT
extern const unsigned char stage3script[];

#define stage3scriptb_bank  FIXEDBANKSLOT
extern const unsigned char stage3scriptb[];

#define stage3_statics_bank  FIXEDBANKSLOT
extern const unsigned int stage3_statics[];

#define stage7_statics_bank  FIXEDBANKSLOT
extern const unsigned int stage7_statics[];


// FUNCTION POInTERS
#define initenemyfunctions_bank FIXEDBANKSLOT;
extern const MyInitEnemyFunction initenemyfunctions[];

#define updateenemyfunctions_bank FIXEDBANKSLOT;
extern const MyUpdateEnemyFunction updateenemyfunctions[];

#define killenemyfunctions_bank FIXEDBANKSLOT;
extern const MyKillEnemyFunction killenemyfunctions[];

#define stage4_scrollers_num 18
extern const signed int stage4_scrollers[];

#define stage1_scrollers_num 4
extern const signed int stage1_scrollers[];

#define stage2_scrollers_num 3
extern const signed int stage2_scrollers[];

#define stage5_scrollers_num 4
extern const signed int stage5_scrollers[];

#define stage3_scrollers_num 2
extern const signed int stage3_scrollers[];

#define stage7_scrollers_num 2
extern const signed int stage7_scrollers[];

#define stage6_scrollers_num 2
extern const signed int stage6_scrollers[];

#define stage8_scrollers_num 2
extern const signed int stage8_scrollers[];

// Listas de sprites
extern const unsigned char *imagepointers[];
extern const int imagebases[];
extern const char imagebanks[];

// By stage
extern const unsigned char stage3spriteslist[];
extern const unsigned char stage1spriteslist[];
extern const unsigned char stage2spriteslist[];
extern const unsigned char stage7spriteslist[];
extern const unsigned char stage6spriteslist[];
extern const unsigned char stage5spriteslist[];
extern const unsigned char stage4spriteslist[];
extern const unsigned char stage8spriteslist[];

// Skull
extern const signed char skullshootvelx[];
extern const signed char skullshootvely[];
extern const signed char skullbshootvelx[];
extern const signed char skullbshootvely[];

// Paleta por defecto
extern const unsigned char palette_bin[];

// Stage 4
extern const unsigned char stage4_stormpalette[];
extern const unsigned char stage4_seapalette[];

// Stage 8
extern const unsigned char stage8animpalette[];

// Stage 1
extern const unsigned char stage1_flashpalette[];

// Arac moving
extern const unsigned char aracmovingx[];
extern const unsigned char aracmovingy[];
extern const unsigned int aracmovingt[];

// Cross A moving
extern const unsigned char crossamovingx[];
extern const unsigned char crossamovingy[];
extern const unsigned int crossamovingt[];

// Cross B moving
extern const unsigned char crossbmovingx[];
extern const unsigned char crossbmovingy[];
extern const unsigned int crossbmovingt[];

// Shoot patterns
extern const signed char stage2endbossshootpatternx[];
extern const signed char stage2endbossshootpatterny[];

// Lasers for enemy of stage 3
extern const unsigned char stage3enemylaserposx[];
extern const unsigned char stage3enemylaserposy[];
extern const unsigned char stage3laservelx[];
extern const unsigned char stage3laservely[];

// Final stage effects 
extern const unsigned char stage6_fade_pink[];
extern const unsigned char stage6_fade_blue[];

// Balls
extern const unsigned char Stage1MiddleBossBPatternX[];
extern const unsigned char Stage1MiddleBossBPatternY[];

// Monster head
extern signed char monsterheadshootdirecionsx[];
extern signed char monsterheadshootdirecionsy[];

extern unsigned char *difficultlabels[];

// Init and update stage functions
extern const MyKillEnemyFunction initstagefunctions[];
extern const MyKillEnemyFunction updatestagefunctions[];

// Bosses
extern const MyInitEnemyFunction updatestage6endbossfunctions[];
extern const MyInitEnemyFunction updatestage5endbossfunctions[];
extern const MyInitEnemyFunction updatestage3endbossfunctions[];
extern const MyInitEnemyFunction updatestage4middlebossfunctions[];
extern const MyInitEnemyFunction updatestage4endbossfunctions[];
extern const MyInitEnemyFunction updatestage7middlebossfunctions[];
extern const MyInitEnemyFunction updatespacestationfunctions[];
extern const MyInitEnemyFunction updatestage2endbossfunctions[];

extern const signed char vulcantankshootspeedx[];
extern const signed char vulcantankshootspeedy[];
extern const signed char vulcanstationshootspeedx[];
extern const signed char vulcanstationshootspeedy[];

extern MyKillEnemyFunction playerupdatefunctions[];

extern const MyCheckCollisionFunction checkcollisionfunctions[];

extern const MyInitEnemyFunction updateintro3objectfunctions[];

extern const MyInitEnemyFunction updatestage8bossafunctions[];
extern const MyInitEnemyFunction updatestage8bossbfunctions[];

extern const signed char stage8bosscshootspeedx[];
extern const signed char stage8bosscshootspeedy[];
extern const signed char stage8bossbshootspeedx[];
extern const signed char stage8bossbshootspeedy[];

extern const unsigned char enemieswidth[];
extern const unsigned char enemiesheight[];
extern const unsigned char enemiesenergy[];