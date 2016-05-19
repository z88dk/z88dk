/*
 *	Adventure A - Some really old 'n' crusty speccy game
 *	[Originally for ZX80/81/82 by Artic Computing]
 *
 *	Compiled under z88dk by djm especially for gwl
 *
 *	djm 19/3/2000
 *  stefano 31/05/2010
 *
 *	Very few changes were needed to get this to work under
 *	z88dk (many changes were made to sccz80 though(!))
 *
 *	Changes to standard source:
 *	 - casts removed in structures
 *	 - Few defines to make life easier
 *   - tape or disk save     (-DTAPE, -DDISK)
 *   - lowercase text taken from the oz700 port in the 'ozdev' web site
 *   - opt graphics scenes   (-DPIC)
 *   - score made optional   (-DCOMPUTE_SCORE)
 *
 *	Found at: http://www.penelope.demon.co.uk/pod/
 *
 *	From the asm source on the same site:
 *
 *	Disassembled, annotated and converted for use with CP/M by
 *	Paul Taylor 18-Aug-1998 With Special thanks to Tim Olmstead
 */


#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <ctype.h>


#ifdef PICS
#include <graphics.h>
#include <adv_a.h>
#endif

#ifdef ACE
#include <ace.h>
#endif

#ifdef SPECTRUM
#define KEY_DEL 12
#endif

#ifdef CPC
#define KEY_DEL 12
#endif

#ifdef Z88
#define KEY_DEL 127
#endif

#ifndef KEY_DEL
#define KEY_DEL '\b'
#endif

#ifndef getkey
#include <conio.h>
#define getkey() getch()
#endif

#ifdef DISK
FILE *fpsave;
#endif

void GetLine();
char i_GetCh();


typedef int BOOL;
typedef unsigned char BYTE;

#define TRUE 1
#define FALSE 0

int GET_TOK();

/*****
; Disassembly of the file "F:\GAMES\SPECCY\A\ARTICADV\Advent_a.sna"
;
; Created with dZ80 v1.30a
;
; on Wednesday, 05 of August 1998 at 11:33 PM
;


		.org	$5d6c

ROM_SAV	.equ	$04c2
ROM_LD	.equ	$0556
ROM_CLS	.equ	$0daf

SCRCT	.equ	$5c8c	; remaining scroll count (system variable)

*/

/* item location codes */

#define NOTX		0xfc
#define ITEM_WORN	0xfd
#define ITEM_HELD	0xfe


/* offsets of game variables */

#define	GVAR_NO_ITEMS	0x01
#define	GVAR_02			0x02
#define	GVAR_03			0x03
#define	GVAR_04			0x04
#define	GVAR_05			0x05
#define	GVAR_06			0x06
#define	GVAR_07			0x07
#define	GVAR_08			0x08
#define	GVAR_09			0x09
#define	GVAR_0a			0x0a
#define	GVAR_0b			0x0b
#define	GVAR_0c			0x0c
#define	GVAR_0d			0x0d
#define	GVAR_0e			0x0e
#define	GVAR_0f			0x0f
#define	GVAR_10			0x10
#define	GVAR_11			0x11
#define	GVAR_12			0x12
#define	GVAR_13			0x13
#define	GVAR_14			0x14
#define	GVAR_15			0x15
#define	GVAR_16			0x16
#define	GVAR_17			0x17
#define	GVAR_18			0x18
#define	GVAR_19			0x19
#define	GVAR_1a			0x1a
#define	GVAR_1b			0x1b
#define	GVAR_1c			0x1c
#define	GVAR_1d			0x1d
#define	GVAR_1e			0x1e



int GVARS[0x1e];		/* workspace of $1e bytes of game variables*/

int F_NTYET;
int		PARAM1;
int CMDFLG;
/*
PREDIX	.equ	$-$29	; PREDIX points here
*/
int VERB_TK;
int NOUN_TK;
BOOL	FLAG;
int		CUR_RM;

char	strTokenBuf[4];		/* workspace of $04 bytes to hold a token*/

#ifdef COMPUTE_SCORE
int nScore;
#endif

#ifdef SPECTRUM
#define MAX_COL 50
#endif
#ifdef Z88
#define MAX_COL 79
#endif

#ifndef MAX_COL
#define MAX_COL 31
#endif

char chaEditLine[MAX_COL + 1];

char* pchEditLine;


int	nRemColumns = MAX_COL;




typedef struct
{
	int		nVerbTok;
	int		nNounTok;
	void*	pPredicates;
	void*	pActions;
} VNDef;


enum blah2 { NA_DO_AUTO, NA_CONTINUE, NA_MAIN, NA_BEGIN, NA_RESTART };

int nNextParseAction;

VNDef* pvndCurrent;
BYTE* pPredicateCurrent;
BYTE* pActionCurrent;




/* ======================================================================
// game instructions
// ======================================================================
*/

char *strInstructions =
    "Welcome to Adventure 'A' - The Planet of Death.\n"
	"In this adventure you find yourself stranded on an alien planet. "
	"Your aim is to escape from this planet by finding your, now captured and disabled, space ship."
	"You will meet varius hazards and dangers on your adventure, some natural, some not, all of which you must overcome to succeed.\n"
	"Good luck, you will need it!\n\n"
	"PRESS ANY KEY TO START\n";

/*
// ======================================================================
// response messages
// ======================================================================
*/

char* straMsg[] =
{
	"It shows a man climbing down a pit using a rope\n",
	"How? I can't reach\n",
	"It has fallen to the floor\n",
	"How?\n",
	"Its too wide. I fell and broke my neck\n",
	"Ugh! He is all slimy\n",
	"He vanished in a puff of smoke\n",
	"You also broke the mirror\n",
	"Computer says: 2 west,2 south for space flight\n",
	"It has weakened it\n",
	"It had no effect\n",
	"I fell and knocked myself out.\n",
	"The bars look loose\n",
	"What with?\n",
	"I see a gold coin\n",
	"Brrr. The waters too cold\n",
	"The fuse has just blown\n",
	"The lift has been activated\n",
	"I see nothing special\n",
	"Keep off the middle men, one may be shocking!\n",
	"Vanity waltz!\n",
	"Try help\n",
	"Points of compass\n",
	"Try looking around\n",
	"I can see a steep slope\n",
	"An alarm sounds. The security guard shot me for trespassing.\n",
	"I can see a rope hanging down the chimney.\n",
	"I am not that daft. It is too deep.\n",
	"The space ship blew up and killed me.\n",
	"The ship has flown into the large lift and is hovering there.\nThere are four buttons outside the window marked 1,2,3 and 4\n",
	"The lift has taken me up to a plateau.\nCongratulations, you have managed to complete this adventure\nwithout getting killed.\n",
	"The lift has become electrified\n",
	"I have been electrocuted\n",
	"It is a good job i was wearing rubber soled boots.\n",
	"I would kill myself if i did.\n",
	"I have turned green and dropped dead.\n",
	"The green man awoke and throttled me.\n",
	"The guard woke and shot me.\n",
	"What at?\n"};



/*
// ======================================================================
// room descriptions
// ======================================================================
*/

char* straRoom[] =
{
    "I am on a mountain plateau\nTo the north there is a steep cliff.\nObvious exits are down, east and west.\n",

    "I am at the edge of a deep pit\nObvious exits are east\n",

    "I am in a damp limestone cave with stalactites hanging down.\nThe exit is to the west\nThere is a passage to the north\n",

    "I am in a dense forest\nThere is a rope hanging from one tree\nObvious exits are south and west\n",

    "I am beside a lake\nExits are east and north. There is a ravine to the west\n",

    "I am in a strange house\nThe door is to the north\n",

	"I am in an old shed\nThe exit is to the east\n",

	"I am in a maze. There are passages everywhere.\n",

	"I am in a maze. There are passages everywhere.\n",

	"I am in a maze. There are passages everywhere.\n",

	"I am in a maze. There are passages everywhere.\n",

	"I am in an ice cavern.\nThere is an exit to the east.\n",

	"I am in a quiet cavern.\nThere are exits west, east and south.\n",

	"I am in a wind tunnel.\nThere is a closed door at the end.\nThere is also an exit to the west.\n",

	"I am in a room with a computer in\nThe computer is working and has a keyboard\nThe exit is west\n",

	"I am in a passage\nThere is a force field to the south : beware of security\nThere are exits to north,east and west\n",

    "I am in a large hanger\nThere is a locked door to the west\nThere are also exits east,north and south\n",

	"I am in a tall lift. The buttons are very high\nThe exit is west\n",

	"I am in the lift control room\nThere are three switches on the wall. They are all off\nA sign says : 5,4 no dusty bin rules\nThe exit is east\n",

	"I am in a prison cell\n",

	"I am in a space ship. There is no visible exit\nThere is a small open window in the side\nThere are also two buttons,one marked main and the other aux.\n"};



/*
// ======================================================================
// item descriptions
// ======================================================================
*/

#define MAX_ITEM 28

char* straItem[MAX_ITEM] =
{
	"a pair of boots",
	"a starter motor",
	"a key",
	"a laser gun",
	"an out of order sign",
	"a metal bar",
	"a gold coin",
	"a mirror",
	"broken glass",
	"a pair of slimy gloves",
	"a rope",
	"a floor board",
	"a broken floor board",
	"stalactites",
	"a block of ice",
	"a pool of water",
	"a small green man sleeping on the mirror",
	"a sleeping green man",
	"a locked door",
	"an open door",
	"a barred window",
	"a hole in the wall",
	"a small but powerfull space ship",
	"a sleeping security man",
	"a piece of sharp flint",
	"some stones",
	"a drawing on the wall",
	"a loudspeaker with dance music coming out"};



/*
// ======================================================================
// initial positions of items - 1 int per item, holds room number
// NOTX indicates item doesn't exist yet
// ======================================================================
*/

int naItemStart[MAX_ITEM] =
{
	0x05, 0x11, 0x0e, 0x06, 0x11, NOTX, NOTX, 0x0c,
	NOTX, 0x0d, NOTX, 0x05, NOTX, NOTX, 0x0b, NOTX,
	0x0c, NOTX, 0x13, NOTX, 0x13, NOTX, 0x10, 0x10,
	0x00, 0x01, 0x02, 0x0f
};

/*
// ======================================================================
// current positions of items - 1 int per item, holds room number
// initialized from naItemStart at start, updated during the game
// NOTX indicates item doesn't exist yet
// ======================================================================
*/

int naItemLoc[MAX_ITEM];



/*
// the commands and their synonyms
// each token is 4 characters, followed by a 1 byte token code
// first define the token codes
*/

#define	TOK_DOWN	0x01
#define	TOK_NORT	0x02
#define	TOK_SOUT	0x03
#define	TOK_EAST	0x04
#define	TOK_WEST	0x05
#define	TOK_GET		0x0d
#define	TOK_DROP	0x0e
#define	TOK_FIRE	0x0f
#define	TOK_BOOT	0x10
#define	TOK_STAR	0x11
#define	TOK_KEY		0x12
#define	TOK_GUN		0x13
#define	TOK_USED	0x14
#define	TOK_BAR		0x15
#define	TOK_COIN	0x16
#define	TOK_MIRR	0x17
#define	TOK_BROK	0x18
#define	TOK_GLOV	0x19
#define	TOK_ROPE	0x1a
#define	TOK_BOAR	0x1b
#define	TOK_STAL	0x1c
#define	TOK_ICE		0x1d
#define	TOK_WATE	0x1e
#define	TOK_MAN		0x1f
#define	TOK_DOOR	0x20
#define	TOK_OPEN	0x21
#define	TOK_WIND	0x22
#define	TOK_SHIP	0x23
#define	TOK_SECU	0x24
#define	TOK_FLIN	0x25
#define	TOK_STON	0x26
#define	TOK_DRAW	0x27
#define	TOK_HELP	0x28
#define	TOK_INVE	0x29
#define	TOK_QUIT	0x2a
#define	TOK_YES		0x2b
#define	TOK_NO		0x2c
#define	TOK_COMP	0x2d
#define	TOK_TYPE	0x2e
#define	TOK_TURN	0x2f
#define	TOK_HAND	0x30
#define	TOK_KILL	0x31
#define	TOK_DANC	0x32
#define	TOK_REMO	0x33
#define	TOK_BREA	0x34
#define	TOK_BRIB	0x35
#define	TOK_USE		0x36
#define	TOK_PUSH	0x37
#define	TOK_THRE	0x38
#define	TOK_TWO		0x39
#define	TOK_ONE		0x3a
#define	TOK_MEND	0x3b
#define	TOK_FOUR	0x3c
#define	TOK_LOOK	0x3d
#define	TOK_STAN	0x3e
#define	TOK_TREE	0x3f
#define	TOK_CUT		0x40
#define	TOK_WEAR	0x41
#define	TOK_CROS	0x42
#define	TOK_JUMP	0x43
#define	TOK_RAVI	0x44
#define	TOK_UP		0x45
#define	TOK_FUSE	0x46
#define	TOK_REDE	0x47
#define	TOK_MAIN	0x48
#define	TOK_AUX		0x49
#define	TOK_FIEL	0x4a



/* now map the codes to their character representations */

typedef struct
{
	char	strWord[5];
	int		nCode;
} TOKEN;

#define MAX_TOK 111

TOKEN taToken[MAX_TOK] =
{
	{ "DOWN", TOK_DOWN },
	{ "D   ", TOK_DOWN },
	{ "NORT", TOK_NORT },
	{ "N   ", TOK_NORT },
	{ "SOUT", TOK_SOUT },
	{ "S   ", TOK_SOUT },
	{ "EAST", TOK_EAST },
	{ "E   ", TOK_EAST },
	{ "WEST", TOK_WEST },
	{ "W   ", TOK_WEST },
	{ "GET ", TOK_GET },
	{ "TAKE", TOK_GET },
	{ "PICK", TOK_GET },
	{ "DROP", TOK_DROP },
	{ "PUT ", TOK_DROP },
	{ "FIRE", TOK_FIRE },
	{ "SHOO", TOK_FIRE },
	{ "BOOT", TOK_BOOT },
	{ "STAR", TOK_STAR },
	{ "MOTO", TOK_STAR },
	{ "KEY ", TOK_KEY },
	{ "LASE", TOK_GUN },
	{ "GUN ", TOK_GUN },
	{ "USED", TOK_USED },
	{ "BAR ", TOK_BAR },
	{ "BARS", TOK_BAR },
	{ "GOLD", TOK_COIN },
	{ "COIN", TOK_COIN },
	{ "MIRR", TOK_MIRR },
	{ "BROK", TOK_BROK },
	{ "GLOV", TOK_GLOV },
	{ "ROPE", TOK_ROPE },
	{ "FLOO", TOK_BOAR },
	{ "BOAR", TOK_BOAR },
	{ "PLAN", TOK_BOAR },
	{ "STAL", TOK_STAL },
	{ "BLOC", TOK_ICE },
	{ "ICE ", TOK_ICE },
	{ "POOL", TOK_WATE },
	{ "WATE", TOK_WATE },
	{ "LAKE", TOK_WATE },
	{ "SLEE", TOK_MAN },
	{ "GREE", TOK_MAN },
	{ "MAN ", TOK_MAN },
	{ "DOOR", TOK_DOOR },
	{ "OPEN", TOK_OPEN },
	{ "UNLO", TOK_OPEN },
	{ "WIND", TOK_WIND },
	{ "SMAL", TOK_SHIP },
	{ "SPAC", TOK_SHIP },
	{ "SHIP", TOK_SHIP },
	{ "SECU", TOK_SECU },
	{ "FLIN", TOK_FLIN },
	{ "STON", TOK_STON },
	{ "DRAW", TOK_DRAW },
	{ "HELP", TOK_HELP },
	{ "INVE", TOK_INVE },
	{ "I   ", TOK_INVE },
	{ "QUIT", TOK_QUIT },
	{ "STOP", TOK_QUIT },
	{ "ABOR", TOK_QUIT },
	{ "YES ", TOK_YES },
	{ "Y   ", TOK_YES },
	{ "NO  ", TOK_NO },
	{ "COMP", TOK_COMP },
	{ "KEYB", TOK_COMP },
	{ "TYPE", TOK_TYPE },
	{ "TURN", TOK_TURN },
	{ "HAND", TOK_HAND },
	{ "KILL", TOK_KILL },
	{ "DANC", TOK_DANC },
	{ "WALT", TOK_DANC },
	{ "REMO", TOK_REMO },
	{ "KICK", TOK_BREA },
	{ "BREA", TOK_BREA },
	{ "HIT ", TOK_BREA },
	{ "BANG", TOK_BREA },
	{ "BRIB", TOK_BRIB },
	{ "USE ", TOK_USE },
	{ "WITH", TOK_USE },
	{ "PUSH", TOK_PUSH },
	{ "THRE", TOK_THRE },
	{ "3   ", TOK_THRE },
	{ "TWO ", TOK_TWO },
	{ "2   ", TOK_TWO },
	{ "ONE ", TOK_ONE },
	{ "1   ", TOK_ONE },
	{ "MEND", TOK_MEND },
	{ "FIX ", TOK_MEND },
	{ "REPA", TOK_MEND },
	{ "FOUR", TOK_FOUR },
	{ "4   ", TOK_FOUR },
	{ "LOOK", TOK_LOOK },
	{ "STAN", TOK_STAN },
	{ "TREE", TOK_TREE },
	{ "CUT ", TOK_CUT },
	{ "SAW ", TOK_CUT },
	{ "WEAR", TOK_WEAR },
	{ "CROS", TOK_CROS },
	{ "JUMP", TOK_JUMP },
	{ "RAVI", TOK_RAVI },
	{ "UP  ", TOK_UP },
	{ "U   ", TOK_UP },
	{ "CLIM", TOK_UP },
	{ "FUSE", TOK_FUSE },
	{ "REDE", TOK_REDE },
	{ "R   ", TOK_REDE },
	{ "MAIN", TOK_MAIN },
	{ "AUX ", TOK_AUX },
	{ "FIEL", TOK_FIEL },
	{ "SHIE", TOK_FIEL }
};













/*
// the directional information, one list for each room
// each list entry is of the form <token code>,<room number>
// each list is terminated with $ff
*/

BYTE DIR_00[] = 
{
	TOK_DOWN,0x03,
	TOK_EAST,0x02,
	TOK_WEST,0x01,
	0xff
};
BYTE DIR_01[] =
{
	TOK_EAST,0x00,
	0xff
};
BYTE DIR_02[] =
{
	TOK_NORT,0x07,
	TOK_WEST,0x00,
	0xff
};
BYTE DIR_03[] =
{
	TOK_SOUT,0x04,
	TOK_WEST,0x00,
	0xff
};
BYTE DIR_04[] =
{
	TOK_NORT,0x03,
	TOK_EAST,0x05,
	0xff
};
BYTE DIR_05[] =
{
	TOK_NORT,0x04,
	0xff
};
BYTE DIR_06[] =
{
	0xff
};
BYTE DIR_07[] =
{
	TOK_DOWN,0x07,
	TOK_NORT,0x08,
	TOK_SOUT,0x07,
	TOK_EAST,0x07,
	TOK_WEST,0x07,
	0xff
};
BYTE DIR_08[] =
{
	TOK_DOWN,0x07,
	TOK_NORT,0x07,
	TOK_SOUT,0x09,
	TOK_EAST,0x07,
	TOK_WEST,0x07,
	0xff
};
BYTE DIR_09[] =
{
	TOK_DOWN,0x07,
	TOK_NORT,0x07,
	TOK_SOUT,0x07,
	TOK_EAST,0x0a,
	TOK_WEST,0x07,
	0xff
};
BYTE DIR_0A[] =
{
	TOK_DOWN,0x07,
	TOK_NORT,0x02,
	TOK_SOUT,0x07,
	TOK_EAST,0x07,
	TOK_WEST,0x0b,
	0xff
};
BYTE DIR_0B[] =
{
	TOK_EAST,0x07,
	0xff
};
BYTE DIR_0C[] =
{
	TOK_SOUT,0x0f,
	TOK_EAST,0x0d,
	TOK_WEST,0x13,
	0xff
};
BYTE DIR_0D[] =
{
	0xff
};
BYTE DIR_0E[] =
{
	TOK_WEST,0x0d,
	0xff
};
BYTE DIR_0F[] =
{
	TOK_EAST,0x13,
	TOK_WEST,0x13,
	0xff
};
BYTE DIR_10[] =
{
	TOK_NORT,0x0f,
	TOK_SOUT,0x13,
	TOK_EAST,0x11,
	0xff
};
BYTE DIR_11[] =
{
	TOK_WEST,0x10,
	0xff
};
BYTE DIR_12[] =
{
	TOK_EAST,0x10,
	0xff
};
BYTE DIR_13[] =
{
	0xff
};


/* this vector array contains an address for every room */

BYTE* DIR_V[] =
{
	DIR_00,
	DIR_01,
	DIR_02,
	DIR_03,
	DIR_04,
	DIR_05,
	DIR_06,
	DIR_07,
	DIR_08,
	DIR_09,
	DIR_0A,
	DIR_0B,
	DIR_0C,
	DIR_0D,
	DIR_0E,
	DIR_0F,
	DIR_10,
	DIR_11,
	DIR_12,
	DIR_13,
	DIR_13		/* room 0x14 shares room 0x13's data - it's just an 0xff anyway */
};
		






/* index codes of predicates */

#define COM_CHKROOM	0x00
#define COM_CHKHERE	0x01
#define COM_CHKRAND	0x02
#define COM_CHKAWAY	0x03
#define COM_CHKWORN	0x04
#define COM_CHKSETF	0x05
#define COM_TSTGVAR	0x06
#define COM_CHKCLRF	0x07
#define COM_CHKHELD	0x08

/* a table of predicates */

BOOL CHKROOM();
BOOL CHKHERE();
BOOL CHKRAND();
BOOL CHKAWAY();
BOOL CHKWORN();
BOOL CHKSETF();
BOOL TSTGVAR();
BOOL CHKCLRF();
BOOL CHKHELD();

#ifdef SCCZ80
int *PRED_V[] = 
#else
BOOL (*PRED_V[])(void) =
#endif
{
	 CHKROOM,					/* $00 */
	 CHKHERE,					/* $01 */
	 CHKRAND,					/* $02 */
	 CHKAWAY,					/* $03 */
	 CHKWORN,					/* $04 */
	 CHKSETF,					/* $05 */
	 TSTGVAR,					/* $06 */
	 CHKCLRF,					/* $07 */
	 CHKHELD					/* $08 */
};

/*
// list of predicate entries 
// first byte is the index of the predicate, see PRED_V
// second byte is stored in PARAM1
// subsequent bytes of entry are terminated with a 0xff
*/


BYTE A_GD_BOOT[] =
{
	COM_CHKHERE,0x00,
	0xff
};
BYTE A_GD_STAR[] =
{
	COM_CHKHERE,0x01,
	0xff
};
BYTE A_GD_KEY[] =
{
	COM_CHKHERE,0x02,
	0xff
};
BYTE A_GD_GUN[] =
{
	COM_CHKHERE,0x03,
	0xff
};
BYTE A_GD_BAR[] =
{
	COM_CHKHERE,0x05,
	0xff
};
BYTE A_GD_COIN[] =
{
	COM_CHKHERE,0x06,
	0xff
};
BYTE A_G_MIRR_1[] =
{
	COM_CHKHERE,0x07,
	COM_CHKAWAY,0x10,
	0xff
};
BYTE A_GD_MIRR_2[] =
{
	COM_CHKHERE,0x08,
	0xff
};
BYTE A_GD_GLOV[] =
{
	COM_CHKHERE,0x09,
	0xff
};
BYTE A_GD_ROPE[] =
{
	COM_CHKHERE,0x0a,
	0xff
};
BYTE A_GD_BOAR_1[] =
{
	COM_CHKHERE,0x0b,
	0xff
};
BYTE A_GD_BOAR_2[] =
{
	COM_CHKHERE,0x0c,
	0xff
};
BYTE A_GD_STAL[] =
{
	COM_CHKHERE,0x0d,
	0xff
};
BYTE A_GD_ICE[] =
{
	COM_CHKHERE,0x0e,
	0xff
};
BYTE A_GD_FLIN[] =
{
	COM_CHKHERE,0x18,
	0xff
};
BYTE A_GD_STON[] =
{
	COM_CHKHERE,0x19,
	0xff
};
BYTE A_D_MIRR[] =
{
	COM_CHKHERE,0x07,
	0xff
};
BYTE A_DRAW_STAL[] =
{
	COM_CHKROOM,0x02,
	0xff
};
BYTE A_U_ICE_1[] =
{
	COM_CHKROOM,0x02,
	COM_CHKHERE,0x0e,
	0xff
};
BYTE A_CUT_ROPE[] =
{
	COM_CHKROOM,0x03,
	0xff
};
BYTE A_USE_FLIN[] =
{
	COM_CHKROOM,0x03,
	COM_CHKHERE,0x18,
	0xff
};
BYTE A_C_RAVI_1[] =
{
	COM_CHKROOM,0x04,
	0xff
};
BYTE A_C_RAVI_2[] =
{
	COM_CHKROOM,0x06,
	0xff
};
BYTE A_C_RAVI_3[] =
{
	COM_CHKROOM,0x04,
	COM_CHKHERE,0x0b,
	0xff
};
BYTE A_USE_BOAR[] =
{
	COM_CHKROOM,0x06,
	COM_CHKHERE,0x0b,
	0xff
};
BYTE A_DOWN[] =
{
	COM_CHKROOM,0x0b,
	0xff
};
BYTE A_U_ICE_2[] =
{
	COM_CHKROOM,0x0b,
	COM_CHKHELD,0x0e,
	0xff
};
BYTE A_G_MAN_1[] =
{
	COM_CHKHERE,0x10,
	COM_CHKHERE,0x09,
	COM_CHKWORN,0x09,
	0xff
};
BYTE A_G_MAN_2[] =
{
	COM_CHKHERE,0x10,
	COM_CHKHERE,0x09,
	0xff
};
BYTE A_G_MAN_3[] =
{
	COM_CHKHERE,0x10,
	0xff
};
BYTE A_KD_MAN_1[] =
{
	COM_CHKHERE,0x11,
	0xff
};
BYTE A_G_MIRR_3[] =
{
	COM_CHKHERE,0x07,
	COM_CHKAWAY,0x10,
	0xff
};
BYTE A_K_MAN_2[] =
{
	COM_CHKHERE,0x10,
	0xff
};
BYTE A_U_GUN_1[] =
{
	COM_CHKHERE,0x10,
	COM_CHKHERE,0x03,
	0xff
};
BYTE A_U_GUN_2[] =
{
	COM_CHKHERE,0x11,
	COM_CHKHERE,0x03,
	COM_CHKHELD,0x11,
	0xff
};
BYTE A_U_GUN_3[] =
{
	COM_CHKHERE,0x11,
	COM_CHKHERE,0x03,
	0xff
};
BYTE A_TYPE_HELP[] =
{
	COM_CHKROOM,0x0e,
	0xff
};
BYTE A_FIRE_GUN[] =
{
	COM_CHKROOM,0x0f,
	0xff
};
BYTE A_FIEL_1[] =
{
	COM_CHKROOM,0x0f,
	COM_CHKCLRF,GVAR_07,
	COM_CHKHERE,0x03,
	0xff
};
BYTE A_FIEL_2[] =
{
	COM_CHKSETF,GVAR_07,
	COM_CHKCLRF,GVAR_08,
	COM_CHKROOM,0x0f,
	COM_CHKHERE,0x03,
	0xff
};
BYTE A_FIEL_3[] =
{
	COM_CHKSETF,GVAR_08,
	COM_CHKROOM,0x0f,
	COM_CHKHERE,0x03,
	0xff
};
BYTE A_DANC_1[] =
{
	COM_CHKROOM,0x0f,
	COM_CHKHELD,0x07,
	COM_CHKSETF,GVAR_08,
	0xff
};
BYTE A_DANC_2[] =
{
	COM_CHKROOM,0x0f,
	0xff
};
BYTE A_O_DOOR_1[] =
{
	COM_CHKROOM,0x10,
	0xff
};
BYTE A_USE_KEY[] =
{
	COM_CHKROOM,0x10,
	COM_CHKHERE,0x02,
	0xff
};
BYTE A_K_SECU[] =
{
	COM_CHKROOM,0x10,
	COM_CHKHERE,0x03,
	0xff
};
BYTE A_LUP_BREA[] =
{
	COM_CHKROOM,0x13,
	0xff
};
BYTE A_UP[] =
{
	COM_CHKROOM,0x13,
	COM_CHKHERE,0x15,
	0xff
};
BYTE A_BRSEC[] =
{
	COM_CHKROOM,0x13,
	0xff
};
BYTE A_U_COIN[] =
{
	COM_CHKROOM,0x13,
	COM_CHKHERE,0x06,
	0xff
};
BYTE A_B_DOOR[] =
{
	COM_CHKROOM,0x13,
	COM_CHKHERE,0x13,
	0xff
};
BYTE A_G_COIN[] =
{
	COM_CHKROOM,0x04,
	COM_CHKAWAY,0x06,
	0xff
};
#define A_L_WATE A_G_COIN
BYTE A_WATE_1[] =
{
	COM_CHKROOM,0x04,
	COM_CHKAWAY,0x06,
	COM_CHKWORN,0x00,
	COM_CHKHERE,0x00,
	0xff
};
BYTE A_WATE_2[] =
{
	COM_CHKROOM,0x04,
	COM_CHKAWAY,0x06,
	COM_CHKHERE,0x00,
	0xff
};
BYTE A_O_DOOR_2[] =
{
	COM_CHKROOM,0x0d,
	0xff
};
BYTE A_PUSH_THRE[] =
{
	COM_CHKROOM,0x12,
	COM_CHKCLRF,GVAR_09,
	COM_CHKCLRF,GVAR_0a,
	0xff
};
BYTE A_PUSH_DIG[] =
{
	COM_CHKROOM,0x12,
	COM_CHKCLRF,GVAR_0a,
	0xff
};
BYTE A_PUSH_TWO[] =
{
	COM_CHKROOM,0x12,
	COM_TSTGVAR,GVAR_09,0x01,
	COM_CHKCLRF,GVAR_0a,
	0xff
};
BYTE A_PUSH_ONE[] =
{
	COM_CHKROOM,0x12,
	COM_TSTGVAR,GVAR_09,0x02,
	COM_CHKCLRF,GVAR_0a,
	0xff
};
BYTE A_MEND_FUSE[] =
{
	COM_CHKROOM,0x12,
	COM_CHKSETF,GVAR_0a,
	0xff
};
BYTE A_USE_BAR[] =
{
	COM_CHKROOM,0x12,
	COM_CHKHERE,0x05,
	COM_CHKSETF,GVAR_0a,
	0xff
};
BYTE A_LOOK[] =
{
	COM_CHKROOM,0x0b,
	0xff
};
BYTE A_HELP_1[] =
{
	COM_CHKROOM,0x11,
	0xff
};
BYTE A_HELP_2[] =
{
	COM_CHKROOM,0x0f,
	0xff
};
BYTE A_HELP_3[] =
{
	COM_CHKROOM,0x0e,
	0xff
};
BYTE A_HELP_4[] =
{
	COM_CHKROOM,0x07,
	0xff
};
BYTE A_HELP_5[] =
{
	COM_CHKROOM,0x08,
	0xff
};
BYTE A_HELP_6[] =
{
	COM_CHKROOM,0x09,
	0xff
};
BYTE A_HELP_7[] =
{
	COM_CHKROOM,0x0a,
	0xff
};
BYTE A_HELP_8[] =
{
	COM_CHKROOM,0x14,
	COM_CHKSETF,GVAR_0c,
	0xff
};
BYTE A_LUP[] =
{
	COM_CHKSETF,GVAR_0b,
	COM_CHKROOM,0x0c,
	0xff
};
BYTE A_WEST[] =
{
	COM_CHKROOM,0x0d,
	0xff
};
BYTE A_JUMP[] =
{
	COM_CHKROOM,0x01,
	0xff
};
BYTE A_USEROP[] =
{
	COM_CHKROOM,0x01,
	COM_CHKHELD,0x0a,
	0xff
};
BYTE A_UPROPE[] =
{
	COM_CHKROOM,0x0c,
	COM_CHKSETF,GVAR_0b,
	0xff
};
BYTE A_SHIP[] =
{
	COM_CHKHERE,0x16,
	0xff
};
BYTE A_P_MAUX[] =
{
	COM_CHKROOM,0x14,
	COM_CHKHERE,0x01,
	0xff
};
BYTE A_P_32[] =
{
	COM_CHKROOM,0x14,
	COM_CHKSETF,GVAR_0c,
	0xff
};
BYTE A_P_41[] =
{
	COM_CHKROOM,0x14,
	COM_CHKSETF,GVAR_0c,
	COM_TSTGVAR,GVAR_09,0x03,
	0xff
};
BYTE A_PSH_ONE_2[] =
{
	COM_CHKROOM,0x14,
	COM_CHKSETF,GVAR_0c,
	COM_CHKWORN,0x00,
	COM_TSTGVAR,GVAR_09,0x03,
	0xff
};



/*
// list of predicate entries for Auto Commands
// first byte is the index of the predicate, see PRED_V
// second byte is stored in PARAM1
// subsequent bytes of entry are terminated with a $ff
// check if we have turned green and died
*/
BYTE A_CHGRN[] =
{
	COM_TSTGVAR,GVAR_05,0x01,		/* if game variable 0x05 = 1     */
	COM_CHKSETF,GVAR_06,			/* and game variable 0x06 is set */
	0xff
};

/* check if the small green man is to throttle us (version 1) */
BYTE A_CHTHR[] =
{
	COM_TSTGVAR,GVAR_02,0x01,		/* if game variable 0x02 = 1 */
	COM_CHKHERE,0x10,			/* and is-present the small green man sleeping on the mirror */
	0xff
};

/* check if the small green man is to throttle us (version 2) */
BYTE A_C2THR[] =
{
	COM_TSTGVAR,GVAR_02,0x01,		/* if game variable 0x02 = 1 */
	COM_CHKHERE,0x11,				/* and is-present the sleeping green man (moved off mirror) */
	0xff
};

/* check if we're to be shot by the security guard */
BYTE A_SHOT[] =
{
	COM_TSTGVAR,GVAR_02,0x01,		/* if game variable 0x02 = 1 */
	COM_CHKHERE,0x17,			/* and is-present the sleeping security man */
	0xff
};

/* check if ice has melted */
BYTE A_MELTD[] =
{
	COM_TSTGVAR,GVAR_02,0x01,		/* if game variable 0x02 = 1 */
	COM_CHKHERE,0x0e,			/* and is-present the block of ice */
	0xff
};

/* an empty action entry */
BYTE A_NULL[] = { 0Xff };

BYTE A_MISC[] = { 0xff };		/* used for auto commands - no predicates required */




#define	I_SH_INVE	0x00		/* terminates bytecode processing */
#define	I_SH_REMO	0x01
#define	I_SH_GET	0x02
#define	I_SH_DROP	0x03
#define	I_SH_WEAR	0x04
#define	I_SH_MSG	0x05
#define	I_SH_REDE	0x06		/* terminates bytecode processing */
#define	I_SH_AUTO	0x07		/* terminates bytecode processing */
#define	I_SH_GOTO	0x08
#define	I_SH_SETF	0x09
#define	I_SH_CLRF	0x0a
#define	I_SH_SWAP	0x0b
#define	I_SH_DEAD	0x0c		/* terminates bytecode processing */
#define	I_SH_OK		0x0d		/* terminates bytecode processing */
#define	I_SH_QUIT	0x0e		/* terminates bytecode processing */
#define	I_SH_SETV	0x0f
#define	I_SH_CREA	0x10
#define	I_SH_DEST	0x11
#define	I_SH_ADSC	0x12
#define	I_SH_SCOR	0x13
#define	I_SH_FAIL1	0x14
#define	I_SH_TELL	0x15
#define	I_SH_FAIL2	0x16
#define	I_SH_FAIL3	0x17
#define	I_SH_FAIL4	0x18



/* bytecodes for the various commands a user can enter */

BYTE SGET_00[] = { I_SH_GET,0x00,I_SH_OK };
BYTE SGET_01[] = { I_SH_GET,0x01,I_SH_OK };
BYTE SGET_02[] = { I_SH_GET,0x02,I_SH_OK };
BYTE SGET_03[] = { I_SH_GET,0x03,I_SH_OK };
BYTE SGET_05[] = { I_SH_GET,0x05,I_SH_OK };
BYTE SGET_06[] = { I_SH_GET,0x06,I_SH_OK };
BYTE SGET_07[] = { I_SH_GET,0x07,I_SH_OK };
BYTE SGET_08[] = { I_SH_GET,0x08,I_SH_OK };
BYTE SGET_09[] = { I_SH_GET,0x09,I_SH_OK };
BYTE SGET_0A[] = { I_SH_GET,0x0a,I_SH_OK };
BYTE SGET_0B[] = { I_SH_GET,0x0b,I_SH_OK };
BYTE SGET_0C[] = { I_SH_GET,0x0c,I_SH_OK };
BYTE SGET_0D[] = { I_SH_GET,0x0d,I_SH_OK };
BYTE SGET_0E[] = { I_SH_GET,0x0e,I_SH_SETV,GVAR_02,0x09,I_SH_OK };
BYTE SGET_18[] = { I_SH_GET,0x18,I_SH_OK };
BYTE SGET_19[] = { I_SH_GET,0x19,I_SH_OK };
BYTE SINVENT[] = { I_SH_INVE,0x07			 };		/* the 0x07 is ignored */
BYTE SQUIT[] = { I_SH_QUIT };
BYTE SPUT_00[] = { I_SH_DROP,0x00,I_SH_OK };
BYTE SPUT_01[] = { I_SH_DROP,0x01,I_SH_OK };
BYTE SPUT_02[] = { I_SH_DROP,0x02,I_SH_OK };
BYTE SPUT_03[] = { I_SH_DROP,0x03,I_SH_OK };
BYTE SPUT_05[] = { I_SH_DROP,0x05,I_SH_OK };
BYTE SPUT_06[] = { I_SH_DROP,0x06,I_SH_OK };
BYTE SPUT_07[] = { I_SH_DROP,0x07,I_SH_OK };
BYTE SPUT_08[] = { I_SH_DROP,0x08,I_SH_OK };
BYTE SPUT_09[] = { I_SH_DROP,0x09,I_SH_OK };
BYTE SPUT_0A[] = { I_SH_DROP,0x0a,I_SH_OK };
BYTE SPUT_0B[] = { I_SH_DROP,0x0b,I_SH_OK };
BYTE SPUT_0C[] = { I_SH_DROP,0x0c,I_SH_OK };
BYTE SPUT_0D[] = { I_SH_DROP,0x0d,I_SH_OK };
BYTE SPUT_0E[] = { I_SH_DROP,0x0e,I_SH_OK };
BYTE SPUT_18[] = { I_SH_DROP,0x18,I_SH_OK };
BYTE SPUT_19[] = { I_SH_DROP,0x19,I_SH_OK };
BYTE SLK_DRW[] = { I_SH_MSG,0x00,I_SH_AUTO };
BYTE SBRK_ST[] = { I_SH_MSG,0x01,I_SH_AUTO };
BYTE SUSE_IC[] = { I_SH_CREA,0x0d,I_SH_MSG,0x02,I_SH_AUTO };
BYTE SCUT_RP[] = { I_SH_MSG,0x03,I_SH_AUTO };
BYTE SUSE_FL[] = { I_SH_CREA,0x0a,I_SH_MSG,0x02,I_SH_AUTO };
BYTE SWR_00[] = { I_SH_WEAR,0x00,I_SH_OK };
BYTE SRM_00[] = { I_SH_REMO,0x00,I_SH_OK };
BYTE SCR_RV[] = { I_SH_MSG,0x03,I_SH_AUTO };
BYTE SUSE_BO[] = { I_SH_GOTO,0x06,I_SH_REDE };
BYTE SUS2_BO[] = { I_SH_GOTO,0x04,I_SH_DEST,0x0b,I_SH_CREA,0x0c,I_SH_REDE };
BYTE SJMP_RV[] = { I_SH_MSG,0x04,I_SH_DEAD };
BYTE SUSE_I2[] = { I_SH_GOTO,0x0c,I_SH_DROP,0x0e,I_SH_SWAP,0x0e,I_SH_SETV,GVAR_02,0x07,I_SH_REDE };
BYTE SGET_MN[] = { I_SH_GET,0x10,I_SH_SWAP,0x10,I_SH_MSG,0x05,I_SH_SETV,GVAR_05,0x0a,I_SH_CLRF,GVAR_06,I_SH_AUTO };
BYTE SGET_M2[] = { I_SH_GET,0x10,I_SH_SWAP,0x10,I_SH_OK };
BYTE SPUT_11[] = { I_SH_DROP,0x11,I_SH_OK };
BYTE SGE2_07[] = { I_SH_GET,0x07,I_SH_OK };
BYTE SGE2_08[] = { I_SH_GET,0x08,I_SH_OK };
BYTE SPU2_07[] = { I_SH_DROP,0x07,I_SH_OK };
BYTE SPU2_08[] = { I_SH_DROP,0x08,I_SH_OK };
BYTE SDO_HOW[] = { I_SH_MSG,0x03,I_SH_AUTO };
BYTE SUSE_GN[] = { I_SH_DEST,0x10,I_SH_SWAP,0x07,I_SH_MSG,0x06,I_SH_MSG,0x07,I_SH_AUTO };
BYTE SFIR_GN[] = { I_SH_MSG,0x26,I_SH_AUTO };
BYTE SUS2_GN[] = { I_SH_DEST,0x11,I_SH_MSG,0x06,I_SH_AUTO };
BYTE SHLP_CM[] = { I_SH_MSG,0x08,I_SH_AUTO };
BYTE SFLD_1[] = { I_SH_SETF,GVAR_07,I_SH_MSG,0x09,I_SH_AUTO };
BYTE SFLD_2[] = { I_SH_SETF,GVAR_08,I_SH_MSG,0x09,I_SH_AUTO };
BYTE SFLD_3[] = { I_SH_MSG,0x0a,I_SH_AUTO };
BYTE SDANCE[] = { I_SH_GOTO,0x10,I_SH_SETV,GVAR_02,0x09,I_SH_REDE };
BYTE SDANCE2[] = { I_SH_MSG,0x0b,I_SH_GOTO,0x13,I_SH_REDE };
BYTE SUSE_KY[] = { I_SH_GOTO,0x12,I_SH_REDE };
BYTE SKIL_SG[] = { I_SH_DEST,0x17,I_SH_OK };
BYTE SLK_UP[] = { I_SH_MSG,0x0c,I_SH_AUTO };
BYTE SBRK_BA[] = { I_SH_SWAP,0x14,I_SH_CREA,0x05,I_SH_REDE };
BYTE SGO_UP[] = { I_SH_GOTO,0x0c,I_SH_SWAP,0x14,I_SH_REDE };
BYTE SBRBSEC[] = { I_SH_MSG,0x0d,I_SH_AUTO };
BYTE SUSE_CN[] = { I_SH_SWAP,0x12,I_SH_DEST,0x06,I_SH_REDE };
BYTE SBDOOR[] = { I_SH_GOTO,0x0c,I_SH_SWAP,0x12,I_SH_REDE };
BYTE SLK_WAT[] = { I_SH_MSG,0x0e,I_SH_AUTO };
BYTE SGET_CN[] = { I_SH_MSG,0x01,I_SH_AUTO };
BYTE SWATER2[] = { I_SH_MSG,0x0f,I_SH_AUTO };
BYTE SWATER1[] = { I_SH_CREA,0x06,I_SH_GET,0x06,I_SH_OK };
BYTE SL2_WAT[] = { I_SH_MSG,0x0f,I_SH_AUTO };
BYTE SODOOR2[] = { I_SH_GOTO,0x0e,I_SH_REDE };
BYTE SPSH3A[] = { I_SH_SETV,GVAR_09,0x01,I_SH_OK };
BYTE SPSHDG[] = { I_SH_MSG,0x10,I_SH_CLRF,GVAR_09,I_SH_SETF,GVAR_0a,I_SH_AUTO };
BYTE SPSH2A[] = { I_SH_SETV,GVAR_09,0x02,I_SH_OK };
BYTE SPSH1A[] = { I_SH_MSG,0x11,I_SH_SETV,GVAR_09,0x03,I_SH_AUTO };
BYTE SMNDFUS[] = { I_SH_MSG,0x0d,I_SH_AUTO };
BYTE SUSE_BA[] = { I_SH_CLRF,GVAR_0a,I_SH_DEST,0x05,I_SH_OK };
BYTE SLOOK1[] = { I_SH_MSG,0x18,I_SH_AUTO };
BYTE SHELP1[] = { I_SH_MSG,0x13,I_SH_AUTO };
BYTE SHELP2[] = { I_SH_MSG,0x14,I_SH_AUTO };
BYTE SHELP3[] = { I_SH_MSG,0x15,I_SH_AUTO };
BYTE SHELP4[] = { I_SH_MSG,0x16,I_SH_AUTO };
BYTE SLK_UP2[] = { I_SH_MSG,0x1a,I_SH_AUTO };
BYTE SQUIET[] = { I_SH_GOTO,0x0c,I_SH_SETV,GVAR_02,0x07,I_SH_REDE };
BYTE SWR_09[] = { I_SH_WEAR,0x09,I_SH_OK };
BYTE SRM_09[] = { I_SH_REMO,0x09,I_SH_OK };
BYTE SREDE[] = { I_SH_REDE };
BYTE SJUMP_D[] = { I_SH_MSG,0x03,I_SH_AUTO };
BYTE SUSE_RP[] = { I_SH_SETF,GVAR_0b,I_SH_DROP,0x0a,I_SH_GOTO,0x0c,I_SH_REDE };
BYTE SJUMP[] = { I_SH_MSG,0x1b,I_SH_AUTO };
BYTE SUP_ROP[] = { I_SH_GOTO,0x01,I_SH_REDE };
BYTE SSHIP[] = { I_SH_GOTO,0x14,I_SH_REDE };
BYTE SPSH_MN[] = { I_SH_MSG,0x1c,I_SH_DEAD };
BYTE SPSH_AU[] = { I_SH_SETF,GVAR_0c,I_SH_MSG,0x1d,I_SH_AUTO };
BYTE SPSH_32[] = { I_SH_MSG,0x19,I_SH_DEAD };
BYTE SPSH_4[] = { I_SH_MSG,0x1e,I_SH_QUIT };
BYTE SPSH_1B[] = { I_SH_MSG,0x1f,I_SH_MSG,0x20,I_SH_DEAD };
BYTE SPSH_1C[] = { I_SH_MSG,0x1f,I_SH_MSG,0x21,I_SH_MSG,0x1e,I_SH_QUIT };
BYTE SHELP5[] = { I_SH_MSG,0x17,I_SH_AUTO };
BYTE SLOOK2[] = { I_SH_MSG,0x12,I_SH_AUTO };





/*
// list of available verb/noun combinations
// along with their defining predicates and
// command lists
// terminated with a zero byte

// for each entry:
// 1st = verb token code
// 2nd = noun token code
// 3rd = address of predicate list entry
// 4th = address of system command list entry
*/

VNDef vndDefinitions[] =
{
	{ TOK_GET,	TOK_BOOT,	 A_GD_BOOT,		 SGET_00 },
	{ TOK_GET,	TOK_STAR,	 A_GD_STAR,		 SGET_01 },
	{ TOK_GET,	TOK_KEY,	 A_GD_KEY,		 SGET_02 },
	{ TOK_GET,	TOK_GUN,	 A_GD_GUN,		 SGET_03 },
	{ TOK_GET,	TOK_BAR,	 A_GD_BAR,		 SGET_05 },
	{ TOK_GET,	TOK_COIN,	 A_GD_COIN,		 SGET_06 },
	{ TOK_GET,	TOK_MIRR,	 A_G_MIRR_1,		 SGET_07 },
	{ TOK_GET,	TOK_MIRR,	 A_GD_MIRR_2,	 SGET_08 },
	{ TOK_GET,	TOK_BROK,	 A_GD_MIRR_2,	 SGET_08 },
	{ TOK_GET,	TOK_GLOV,	 A_GD_GLOV,		 SGET_09 },
	{ TOK_GET,	TOK_ROPE,	 A_GD_ROPE,		 SGET_0A },
	{ TOK_GET,	TOK_BOAR,	 A_GD_BOAR_1,	 SGET_0B },
	{ TOK_GET,	TOK_BOAR,	 A_GD_BOAR_2,	 SGET_0C },
	{ TOK_GET,	TOK_BROK,	 A_GD_BOAR_2,	 SGET_0C },
	{ TOK_GET,	TOK_STAL,	 A_GD_STAL,	 SGET_0D },
	{ TOK_GET,	TOK_ICE,	 A_GD_ICE,	 SGET_0E },
	{ TOK_GET,	TOK_FLIN,	 A_GD_FLIN,		 SGET_18 },
	{ TOK_GET,	TOK_STON,	 A_GD_STON,		 SGET_19 },
	{ TOK_INVE, 0xff,		 A_MISC,			 SINVENT },
	{ TOK_QUIT, 0xff,		 A_MISC,			 SQUIT },
	{ TOK_DROP,	TOK_BOOT,	 A_GD_BOOT,		 SPUT_00 },
	{ TOK_DROP,	TOK_STAR,	 A_GD_STAR,		 SPUT_01 },
	{ TOK_DROP,	TOK_KEY,	 A_GD_KEY,		 SPUT_02 },
	{ TOK_DROP,	TOK_GUN,	 A_GD_GUN,		 SPUT_03 },
	{ TOK_DROP,	TOK_BAR,	 A_GD_BAR,		 SPUT_05 },
	{ TOK_DROP,	TOK_COIN,	 A_GD_COIN,		 SPUT_06 },
	{ TOK_DROP,	TOK_MIRR,	 A_D_MIRR,		 SPUT_07 },
	{ TOK_DROP,	TOK_MIRR,	 A_GD_MIRR_2,	 SPUT_08 },
	{ TOK_DROP,	TOK_BROK,	 A_GD_MIRR_2,	 SPUT_08 },
	{ TOK_DROP,	TOK_GLOV,	 A_GD_GLOV,		 SPUT_09 },
	{ TOK_DROP,	TOK_ROPE,	 A_GD_ROPE,		 SPUT_0A },
	{ TOK_DROP,	TOK_BOAR,	 A_GD_BOAR_1,	 SPUT_0B },
	{ TOK_DROP,	TOK_BOAR,	 A_GD_BOAR_2,	 SPUT_0C },
	{ TOK_FIRE,	TOK_BROK,	 A_GD_BOAR_2,	 SPUT_0C },
	{ TOK_DROP,	TOK_STAL,	 A_GD_STAL,		 SPUT_0D },
	{ TOK_DROP,	TOK_ICE,	 A_GD_ICE,		 SPUT_0E },
	{ TOK_DROP,	TOK_FLIN,	 A_GD_FLIN,		 SPUT_18 },
	{ TOK_DROP,	TOK_STON,	 A_GD_STON,		 SPUT_19 },
	{ TOK_LOOK,	TOK_DRAW,	 A_DRAW_STAL,	 SLK_DRW },
	{ TOK_BREA,	TOK_STAL,	 A_DRAW_STAL,	 SBRK_ST },
	{ TOK_USE,	TOK_ICE,	 A_U_ICE_1,		 SUSE_IC },
	{ TOK_CUT,	TOK_ROPE,	 A_CUT_ROPE,		 SCUT_RP },
	{ TOK_USE,	TOK_FLIN,	 A_USE_FLIN,		 SUSE_FL },
	{ TOK_WEAR,	TOK_BOOT,	 A_MISC,			 SWR_00 },
	{ TOK_REMO,	TOK_BOOT,	 A_MISC,			 SRM_00 },
	{ TOK_CROS,	TOK_RAVI,	 A_C_RAVI_1,		 SCR_RV },
	{ TOK_CROS,	TOK_RAVI,	 A_C_RAVI_2,		 SCR_RV },
	{ TOK_USE,	TOK_BOAR,	 A_C_RAVI_3,		 SUSE_BO },
	{ TOK_USE,	TOK_BOAR,	 A_USE_BOAR,		 SUS2_BO },
	{ TOK_JUMP,	TOK_RAVI,	 A_C_RAVI_3,		 SJMP_RV },
	{ TOK_JUMP,	TOK_RAVI,	 A_C_RAVI_2,		 SJMP_RV },
	{ TOK_DOWN, 0xff,		 A_DOWN,			 SCR_RV },
	{ TOK_USE,	TOK_ICE,	 A_U_ICE_2,		 SUSE_I2 },
	{ TOK_GET,	TOK_MAN,	 A_G_MAN_1,		 SGET_MN },
	{ TOK_GET,	TOK_MAN,	 A_G_MAN_2,		 SGET_M2 },
	{ TOK_GET,	TOK_MAN,	 A_G_MAN_3,		 SGET_MN },
	{ TOK_DROP,	TOK_MAN,	 A_KD_MAN_1,		 SPUT_11 },
	{ TOK_GET,	TOK_MIRR,	 A_G_MIRR_3,		 SGE2_07 },
	{ TOK_GET,	TOK_BROK,	 A_GD_MIRR_2,	 SGE2_08 },
	{ TOK_DROP,	TOK_MIRR,	 A_D_MIRR,		 SPU2_07 },
	{ TOK_DROP,	TOK_BROK,	 A_GD_MIRR_2,	 SPU2_08 },
	{ TOK_KILL,	TOK_MAN,	 A_K_MAN_2,		 SDO_HOW },
	{ TOK_KILL,	TOK_MAN,	 A_KD_MAN_1,		 SDO_HOW },
	{ TOK_USE,	TOK_GUN,	 A_U_GUN_1,		 SUSE_GN },
	{ TOK_USE,	TOK_GUN,	 A_U_GUN_2,		 SFIR_GN },
	{ TOK_USE,	TOK_GUN,	 A_U_GUN_3,		 SUS2_GN },
	{ TOK_TYPE,	TOK_HELP,	 A_TYPE_HELP,	 SHLP_CM },
	{ TOK_FIRE,	TOK_GUN,	 A_FIRE_GUN,		 SFIR_GN },
	{ TOK_FIEL, 0xff,		 A_FIEL_1,		 SFLD_1 },
	{ TOK_FIEL, 0xff,		 A_FIEL_2,		 SFLD_2 },
	{ TOK_FIEL, 0xff,		 A_FIEL_3,		 SFLD_3 },
	{ TOK_DANC, 0xff,		 A_DANC_1,		 SDANCE },
	{ TOK_DANC, 0xff,		 A_DANC_2,		 SDANCE2 },
	{ TOK_OPEN,	TOK_DOOR,	 A_O_DOOR_1,		 SDO_HOW },
	{ TOK_USE,	TOK_KEY,	 A_USE_KEY,		 SUSE_KY },
	{ TOK_KILL,	TOK_SECU,	 A_K_SECU,		 SKIL_SG },
	{ TOK_LOOK,	TOK_UP,		 A_LUP_BREA,		 SLK_UP },
	{ TOK_BREA,	TOK_BAR,	 A_LUP_BREA,		 SBRK_BA },
	{ TOK_UP,	0xff,		 A_UP,			 SGO_UP },
	{ TOK_BRIB,	TOK_SECU,	 A_BRSEC,		 SBRBSEC },
	{ TOK_USE,	TOK_COIN,	 A_U_COIN,		 SUSE_CN },
	{ TOK_DOOR, 0xff,		 A_B_DOOR,		 SBDOOR },
	{ TOK_LOOK,	TOK_WATE,	 A_L_WATE,		 SLK_WAT },
	{ TOK_GET,	TOK_COIN,	 A_G_COIN,		 SGET_CN },
	{ TOK_WATE, 0xff,		 A_WATE_1,		 SWATER1 },
	{ TOK_WATE, 0xff,		 A_WATE_2,		 SWATER2 },
	{ TOK_WATE, 0xff,		 A_L_WATE,		 SL2_WAT },
	{ TOK_OPEN,	TOK_DOOR,	 A_O_DOOR_2,		 SODOOR2 },
	{ TOK_PUSH,	TOK_THRE,	 A_PUSH_THRE,	 SPSH3A },
	{ TOK_PUSH,	TOK_THRE,	 A_PUSH_DIG,		 SPSHDG },
	{ TOK_PUSH,	TOK_TWO,	 A_PUSH_TWO,		 SPSH2A },
	{ TOK_PUSH,	TOK_TWO,	 A_PUSH_DIG,		 SPSHDG },
	{ TOK_PUSH,	TOK_ONE,	 A_PUSH_ONE,		 SPSH1A },
	{ TOK_PUSH,	TOK_ONE,	 A_PUSH_DIG,		 SPSHDG },
	{ TOK_MEND,	TOK_FUSE,	 A_MEND_FUSE,	 SMNDFUS },
	{ TOK_USE,	TOK_BAR,	 A_USE_BAR,		 SUSE_BA },
	{ TOK_LOOK, 0xff,		 A_LOOK,			 SLOOK1 },
	{ TOK_HELP, 0xff,		 A_HELP_1,		 SHELP1 },
	{ TOK_HELP, 0xff,		 A_HELP_2,		 SHELP2 },
	{ TOK_HELP, 0xff,		 A_HELP_3,		 SHELP3 },
	{ TOK_HELP, 0xff,		 A_HELP_4,		 SHELP4 },
	{ TOK_HELP, 0xff,		 A_HELP_5,		 SHELP4 },
	{ TOK_HELP, 0xff,		 A_HELP_6,		 SHELP4 },
	{ TOK_HELP, 0xff,		 A_HELP_7,		 SHELP4 },
	{ TOK_HELP, 0xff,		 A_HELP_8,		 SHELP1 },
	{ TOK_LOOK,	TOK_UP,		 A_LUP,			 SLK_UP2 },
	{ TOK_WEST, 0xff,		 A_WEST,			 SQUIET },
	{ TOK_NORT, 0xff,		 A_HELP_2,		 SQUIET },
	{ TOK_WEAR,	TOK_GLOV,	 A_MISC,			 SWR_09 },
	{ TOK_REMO,	TOK_GLOV,	 A_MISC,			 SRM_09 },
	{ TOK_REDE, 0xff,		 A_MISC,			 SREDE },
	{ TOK_DOWN, 0xff,		 A_JUMP,			 SJUMP_D },
	{ TOK_USE,	TOK_ROPE,	 A_USEROP,		 SUSE_RP },
	{ TOK_JUMP, 0xff,		 A_JUMP,			 SJUMP },
	{ TOK_UP,	TOK_ROPE,	 A_UPROPE,		 SUP_ROP },
	{ TOK_SHIP, 0xff,		 A_SHIP,			 SSHIP },
	{ TOK_PUSH,	TOK_MAIN,	 A_P_MAUX,		 SPSH_MN },
	{ TOK_PUSH,	TOK_AUX,	 A_P_MAUX,		 SPSH_AU },
	{ TOK_PUSH,	TOK_THRE,	 A_P_32,			 SPSH_32 },
	{ TOK_PUSH,	TOK_TWO,	 A_P_32,			 SPSH_32 },
	{ TOK_PUSH,	TOK_FOUR,	 A_P_41,			 SPSH_4 },
	{ TOK_PUSH,	TOK_ONE,	 A_PSH_ONE_2,	 SPSH_1C },
	{ TOK_PUSH,	TOK_ONE,	 A_P_41,			 SPSH_1B },
	{ TOK_HELP, 0xff,		 A_MISC,			 SHELP5 },
	{ TOK_LOOK, 0xff,		 A_MISC,			 SLOOK2 },
	{ 0x00,		0x00,		 0,				 0 }
};






/* bytecodes for the auto commands */
BYTE STURNGR[] = { I_SH_MSG,0x23,I_SH_DEAD };
BYTE STHROTL[] = { I_SH_MSG,0x24,I_SH_DEAD };
BYTE SSHOT[] = { I_SH_MSG,0x25,I_SH_DEAD };
BYTE SMELT_I[] = { I_SH_SWAP,0x0e,I_SH_TELL };
BYTE STELLME[] = { I_SH_TELL };



/*
// list of auto command combinations
// terminated with a zero byte
// these processed at the end of each parse cycle

// for each entry:
// 1st = verb token code (wildcard, matches any verb)
// 2nd = noun token code (wildcard, matches any noun)
// 3rd = address of predicate list entry
// 4th = unknown address
*/

VNDef AUT_LST[] = 
{
	{ 0xff, 0xff,  A_CHGRN,  STURNGR },
	{ 0xff, 0xff,  A_CHTHR,  STHROTL },
	{ 0xff, 0xff,  A_C2THR,  STHROTL },
	{ 0xff, 0xff,  A_SHOT,   SSHOT },
	{ 0xff, 0xff,  A_MELTD,  SMELT_I },
	{ 0xff, 0xff,  A_NULL,   STELLME }
};



/*
// ======================================================================
// output a character to the display
// ======================================================================
*/

void i_PutCh(char ch)
{
	putchar(ch);

	if (ch == '\n')
		nRemColumns = MAX_COL;

}

/*
// ======================================================================
// throw a new line on the display
// ======================================================================
*/

void PrintCR()
{
	i_PutCh('\n');
}

/*
// ======================================================================
// clear the screen
// ======================================================================
*/

void ClearScr()
{
	putchar(12);
	/*
	int n;
	for (n = 0; n < 50; ++n)
		printf("\n");

	nRemColumns = MAX_COL;
	*/
}

/*
// ======================================================================
// print the zero-terminated string pointed to by HL
// performing word-wrap and scrolling if necessary
// ======================================================================
*/

void PrintStr(unsigned char* hl)
{
	unsigned char ch;
	unsigned char *temphl;
	int b;


	for (;;)
	{
		ch = *hl++;
		if (ch == 0)
			return;

		switch (ch)
		{
		case '\n':
			PrintCR();
			break;

		case ' ':
			break;

		default:
			--hl;
			temphl = hl;
			b = 0;
        
			for (;;)
			{
				ch = *hl;
				if ((ch == ' ') || (ch == '\0') || (ch == '\n'))
					break;
				++b;
				++hl;
			}

			if (b > nRemColumns)
				PrintCR();

			hl = temphl;

			for (;;)
			{
				ch = *hl;
				if ((ch == ' ') || (ch == '\0') || (ch == '\n'))
					break;

				i_PutCh(ch);
				++hl;
			}

			if ((nRemColumns - b) != 0)
			{
				i_PutCh(' ');
				nRemColumns = nRemColumns - b - 1;
			}
			else
				nRemColumns = nRemColumns - b;

			break;
		}
	}
}




/****

; main program starts here

START	ld      hl,GVARS				; zero all game variables
      	ld      b,$1e
INITLP	ld      (hl),$00
      	inc     hl
        djnz    INITLP

      	ld      hl,$0000
      	ld      (SCORE),hl
      	call    PrintInstr					; display instructions
      	
		// copied to main - initialize naItemLoc
		
      	ld      ix,GVARS				; initialize ix to point at the game variables
      	ld      (CUR_RM),$00	; set current room to 0 (starting room)
      	push    hl						; save hl (points at naItemLoc)
      	jr      RESTG					; skip message data...

RESTG_M	.text	"WANT TO RESTORE A GAME?"
		.byte	$0d,$00

RESTG	ld      hl,RESTG_M				; prompt - restore game?
      	call    PrintStr					; print it
      	pop     hl						; restore hl (points at naItemLoc)
      	call    i_GetCh

      	cp      'Y'
      	call    z,LCASS					; user typed 'Y', go and restore game


; main execution loop

MAIN	call    ClearScr
        xor     a
      	cp      (ix+$00)				; if (ix+$00) is zero,
      	jr      z,ROOM					; go and display the room description
      	cp      (ix+$03)				; if (ix+$03) is zero,
      	jr      z,DARK_CH				; go straight to the dark check
        dec     (ix+$03)				; otherwise, decrement (ix+$03)

DARK_CH	ld      a,(naItemLoc)				; get location of item $00
      	cp      (CUR_RM)		; check whether it's in the current room
      	jr      z,ROOM					; if it is, it's not dark
      	push    hl
      	jr      DARK					; skip message data...

DARK_M	.text	"EVERYTHING IS DARK.I CANT SEE."
		.byte	$0d,$00

DARK	ld      hl,DARK_M				; say it's dark and we can't see
      	call    PrintStr
      	pop     hl
        xor     a
      	cp      (ix+$04)				; if (ix+$04) is zero,
      	jr      z,DARK_ND				; go straight to ????????
        dec     (ix+$04)				; otherwise, decrement (ix+$04)

DARK_ND	jr      DO_AUTO					; (96)


****/


/* display description for current room */

void ShowRoom()
{
	int nItem;

#ifdef PICS
	switch(CUR_RM)
	{
		case 0:
			draw_profile(60, 60, 160, mountain);
			draw_profile(63, 63, 152, mountain);
			draw(135,73,175,71);
			draw_profile(80, 80, 240, tree2);
			draw_profile(80, 120, 80, mountain);
			draw_profile(60, 110, 200, tree2);
			break;
		case 3:
			for (nItem = 1; nItem < 5; ++nItem) {
				draw_profile(nItem*10-rand()%100, 20+rand()%40, 170+nItem*20, tree2);
				draw_profile(60-rand()%100, nItem+rand()%40, 170+nItem*20, tree1);
			}
			break;
		case 4:
			draw_profile(50, 20, 160, lake);
			break;
		case 5:
			//draw_profile(50, 20, 240, strange_house);
			break;
		case 6:
			draw_profile(60, 3, 180, shed);
			break;
		case 7:
		case 8:
		case 9:
		case 10:
			draw_profile(60, 60, 240, maze);
			break;
		case 14:
			draw_profile(20, 100, 200, keyboard);
			break;
		case 19:
			draw_profile(60, 20, 160, jail);
			break;

	}
#endif

	PrintStr(straRoom[CUR_RM]);

	FLAG = FALSE;
	for (nItem = 0; nItem < MAX_ITEM; ++nItem)
	{
		if (naItemLoc[nItem] == CUR_RM)
		{
			if (!FLAG)
			{
				PrintStr("I can also see :\n");
				FLAG = TRUE;
			}
			PrintStr(straItem[nItem]);
			PrintCR();
		}
	}

	nNextParseAction = NA_DO_AUTO;
}
/*****

// ======================================================================
// perform regular automatic functions, e.g. the little green man
// ======================================================================

void DO_AUTO()
{
	ld      hl,AUT_LST				; select the auto command list (wildcards, every command matches)
      	jp      PARS_LP					; and restart parser


***/

/*
// ======================================================================
// system command - TELL command
// generates the "tell me what to do" prompt
// ======================================================================
*/

void SH_TELL()
{
	BYTE* pDirections;

	if (GVARS[GVAR_02] > 0)
		--GVARS[GVAR_02];

	if (GVARS[GVAR_05] > 0)
		--GVARS[GVAR_05];

	/***
	{
		char sz[256];
		sprintf(sz, "02 = %u\n", GVARS[0x02]);
		PrintStr(sz);
	}
	***/

	PrintStr("Tell me what to do \n");

	GetLine();
	F_NTYET = FALSE;
/*
// ======================================================================
// fetch verb token from the input buffer
// ======================================================================
*/

	pchEditLine = chaEditLine;

	for (;;)
	{
		VERB_TK = GET_TOK();
		if (VERB_TK == 0xff)
		{
			BOOL bDont = FALSE;
			if ((*pchEditLine == '\n') || (*pchEditLine == '\0'))
				bDont = TRUE;
			else
			{
				for (;;)
				{
					if (*pchEditLine == ' ')
					{
						++pchEditLine;
						goto verb_outer_continue;
					}
					else if ((*pchEditLine == '\n') || (*pchEditLine == '\0'))
					{
						bDont = TRUE;
						break;
					}
					++pchEditLine;
				}
			}

			if (bDont)
			{
				PrintStr("I don't understand\n");
				nNextParseAction = NA_DO_AUTO;
				return;
			}
		}
		else
			break;		/* verb ok */

verb_outer_continue:
		continue;
	}

	/* verb recognized */
	NOUN_TK = 0xff;		/* assume noun unrecognized before reading on */


	/* trim off excess characters from the verb */
	for (;;)
	{
		char ch = *pchEditLine;

		if (ch == ' ')
			break;

		if (ch == '\0')
			goto P_DIR;

		if (ch == '\n')
			goto P_DIR;

		++pchEditLine;
	}

/*
// ======================================================================
// fetch noun token from the input buffer
// ======================================================================
*/

	for (;;)
	{
		++pchEditLine;
		NOUN_TK = GET_TOK();


		if (NOUN_TK != 0xff)
			break;

		for (;;)
		{
			char ch = *pchEditLine;

			if (ch == ' ')
				break;

			if (ch == '\0')
				goto P_DIR;

			if (ch == '\n')
				goto P_DIR;

			++pchEditLine;
		}
	}

/*
// ======================================================================
// attempt to parse a direction verb
// ======================================================================
*/

P_DIR:

	pDirections = DIR_V[CUR_RM];

	for (;;)
	{
		int nDir  =  *pDirections;

		if (nDir == 0xff)
			break;

		if (nDir == VERB_TK)
		{
			CUR_RM = pDirections[1];
			nNextParseAction = NA_MAIN;
			return;
		}

		pDirections += 2;
	}

	pvndCurrent = vndDefinitions;
	CMDFLG = FALSE;
	nNextParseAction = NA_BEGIN;
}

extern void *SYS_V[];

void PARSE_LP()
{
	int nVerbTok = pvndCurrent->nVerbTok;

	if (nVerbTok == 0)
	{
		if (!CMDFLG)
		{
			if (VERB_TK < TOK_GET)		/* direction? */
				PrintStr("I can't go in that direction\n");
			else if (F_NTYET)
				PrintStr("I can't do that yet\n");
			else
				PrintStr("I can't\n");
		}
		nNextParseAction = NA_DO_AUTO;
		return;
	}

	if ((nVerbTok == 0xff) || (nVerbTok == VERB_TK))
	{
		int nNounTok = pvndCurrent->nNounTok;

		if ((nNounTok == 0xff) || (nNounTok == NOUN_TK))
		{
			int nPred;
			pPredicateCurrent = (BYTE*) pvndCurrent->pPredicates;

			while ((nPred = *pPredicateCurrent++) != 0xff)
			{
				BOOL (*pfn)() = PRED_V[nPred];
				PARAM1 = *pPredicateCurrent;
				if (!pfn())
				{
					F_NTYET = TRUE;
					nNextParseAction = NA_CONTINUE;
					return;
				}
				++pPredicateCurrent;
			}
			/* execute command */
			pActionCurrent = (BYTE*) pvndCurrent->pActions;
			CMDFLG = TRUE;

			nNextParseAction = NA_CONTINUE;

			for (;;)
			{
				if (*pActionCurrent == 0xff)
					return;
				else
				{
					void (*pfn)() = (void*) (SYS_V[*pActionCurrent++]);

					PARAM1 = *pActionCurrent;
					pfn();

					if (nNextParseAction != NA_CONTINUE)
						return;

					++pActionCurrent;
				}
			}



			PrintStr("Executed!\n");
		}
	}

	nNextParseAction = NA_CONTINUE;
	return;
}







/* predicates */


/*
// predicate CHKROOM - this tests the current room number to make sure it's the specified room number.
// if it is, we move on to the next command, otherwise we trigger a "i can't do that yet" response.
// this handler interprets PARAM1 as the room number
*/

BOOL CHKROOM()
{
	return PARAM1 == CUR_RM;
}


/*
// predicate for GET and DROP commands
// this handler interprets PARAM1 as the item number
*/

BOOL CHKHERE()
{
	int nLoc = naItemLoc[PARAM1];
    
	return (nLoc == CUR_RM) || (nLoc >= ITEM_WORN);
}

/*
// predicate CHKRAND - randomly allows or disallows the user's command.
// if allowed, we move on to the next command, otherwise we trigger a "i can't do that yet" response.
*/

BOOL CHKRAND()
{
	return (rand() % 256) < PARAM1;
}


/*
// predicate CHKAWAY - checks that the specified item is not carried, held or in the current room.
// if it is NOT, we move on to the next command, otherwise we trigger a "i can't do that yet" response.
// this handler interprets PARAM1 as the item number
*/

BOOL CHKAWAY()
{
	return !CHKHERE();
}


/*
// predicate CHKWORN - checks that the specified item is being worn.
// if it is, we move on to the next command, otherwise we trigger a "i can't do that yet" response.
// this handler interprets PARAM1 as the item number
*/

BOOL CHKWORN()
{
	return naItemLoc[PARAM1] == ITEM_WORN;
}


/*
// predicate CHKSETF - checks the game variable specified by PARAM1.
// if it is non-zero, we move on to the next command, otherwise we trigger a "i can't do that yet" response.
// this handler interprets PARAM1 as the game variable number
// used by "field" and "look up"
*/

BOOL CHKSETF()
{
	return !!GVARS[PARAM1];
}



/*
// predicate TSTGVAR - compares the game variable specified by PARAM1 with the value specified as
// the next byte after the command.
// if it is equal, we move on to the next command, otherwise we trigger a "i can't do that yet" response.
// this handler interprets PARAM1 as the game variable number
*/

BOOL TSTGVAR()
{
	int nParam2 = *++pPredicateCurrent;
	return GVARS[PARAM1] == nParam2;
}


/*
// predicate CHKCLRF - checks the game variable specified by PARAM1.
// if it is zero, we move on to the next command, otherwise we trigger a "i can't do that yet" response.
// this handler interprets PARAM1 as the game variable number
*/

BOOL CHKCLRF()
{
	return !CHKSETF();
}


/*
// predicate CHKHELD - checks that the specified item is being carried (or worn!).
// if it is, we move on to the next command, otherwise we trigger a "i can't do that yet" response.
// this handler interprets PARAM1 as the item number
*/

BOOL CHKHELD()
{
	return (naItemLoc[PARAM1] == ITEM_HELD) || (naItemLoc[PARAM1] == ITEM_WORN);
}


/***






; fetch location for an item
; item number is in PARAM1
; location is returned in A
; address of location entry is returned in HL

GET_LOC	ld      hl,naItemLoc
      	ld      b,$00
        ld      c,(PARAM1)
      	add     hl,bc
      	ld      a,(hl)
      	ret     




***/



void SH_INVE()
{
	int bNothing=TRUE;
	int nItem;
	int nLoc;

	PrintStr("I have with me the following:\n");

	for (nItem = 0; nItem < MAX_ITEM; ++nItem)
	{
		nLoc = naItemLoc[nItem];

		if (nLoc >= ITEM_WORN)
		{
			bNothing = FALSE;
			PrintStr(straItem[nItem]);
			if (nLoc == ITEM_WORN)
				PrintStr(" which i am wearing");
			PrintCR();
		}
	}

	if (bNothing)
		PrintStr("Nothing at all\n");

	nNextParseAction = NA_DO_AUTO;
}


/*
// ======================================================================
// system command - REMOVE command
// item to be removed is specified in PARAM1
// ======================================================================
*/

void SH_REMO()
{
	if (naItemLoc[PARAM1] == ITEM_WORN)
	{
		if (GVARS[GVAR_NO_ITEMS] == 6)
		{
			PrintStr("I cant. My hands are full\n");
			nNextParseAction = NA_DO_AUTO;
		}
		else
		{
			naItemLoc[PARAM1] = ITEM_HELD;
			++GVARS[GVAR_NO_ITEMS];
		}
	}
	else
	{
		PrintStr("I am not wearing it\n");
		nNextParseAction = NA_DO_AUTO;
	}
}




/*
// ======================================================================
// system command - GET command
// item to be got is specified in PARAM1
// ======================================================================
*/

void SH_GET()
{
	if (GVARS[GVAR_NO_ITEMS] == 6)
	{
		PrintStr("I can't carry any more\n");
		nNextParseAction = NA_DO_AUTO;
	}
	else if (naItemLoc[PARAM1] == CUR_RM)
	{
		naItemLoc[PARAM1] = ITEM_HELD;
		++GVARS[GVAR_NO_ITEMS];
	}
	else if ((naItemLoc[PARAM1] == ITEM_WORN) || (naItemLoc[PARAM1] == ITEM_HELD))
	{
		PrintStr("I already have it\n");
		nNextParseAction = NA_DO_AUTO;
	}
	else
	{
		PrintStr("I don't see it here\n");
		nNextParseAction = NA_DO_AUTO;
	}
}

/*
// ======================================================================
// system command - DROP command
// item to be dropped is specified in PARAM1
// ======================================================================
*/

void SH_DROP()
{
	if (naItemLoc[PARAM1] == CUR_RM)
	{
		PrintStr("I don't have it\n");
		nNextParseAction = NA_DO_AUTO;
	}
	else if (naItemLoc[PARAM1] == ITEM_WORN)
	{
		naItemLoc[PARAM1] = CUR_RM;
	}
	else if (naItemLoc[PARAM1] == ITEM_HELD)
	{
		--GVARS[GVAR_NO_ITEMS];
		naItemLoc[PARAM1] = CUR_RM;
	}
	else
	{
		PrintStr("I don't have it\n");
		nNextParseAction = NA_DO_AUTO;
	}
}


/*
// ======================================================================
// system command - WEAR command
// item to be worn is specified in PARAM1
// ======================================================================
*/

void SH_WEAR()
{
	if (naItemLoc[PARAM1] == ITEM_HELD)
	{
		naItemLoc[PARAM1] = ITEM_WORN;
		--GVARS[GVAR_NO_ITEMS];
	}
	else if (naItemLoc[PARAM1] == ITEM_WORN)
	{
		PrintStr("I am already wearing it\n");
		nNextParseAction = NA_DO_AUTO;
	}
	else
	{
		PrintStr("I don't have it\n");
		nNextParseAction = NA_DO_AUTO;
	}
}


/*
// ======================================================================
// system command - display a response
// index of response to be displayed is specified in PARAM1
// ======================================================================
*/


BOOL SH_MSG()
{
	PrintStr(straMsg[PARAM1]);
	return TRUE;
}


/*
// ======================================================================
// system command - REDE
// redescribe current room, terminating execution of system commands
// ======================================================================
*/

void SH_REDE()
{
	nNextParseAction = NA_MAIN;
}

/*
// ======================================================================
// exactly the same effect as SH_FAIL - it halts further system command
// processing,
// and proceeds to execute the auto commands.
// ======================================================================
*/

void SH_AUTO()
{
	nNextParseAction = NA_DO_AUTO;
}

/*
// ======================================================================
// system command - go directly to specific room (do not pass go)
// index of room is specified in PARAM1
// NB: room description not automatically displayed
// ======================================================================
*/

void SH_GOTO()
{
	CUR_RM = PARAM1;
}


/*
// ======================================================================
// system command SETF - set game variable to $ff
// index of variable to set is specified in PARAM1
// ======================================================================
*/

void SH_SETF()
{
	GVARS[PARAM1] = 0xff;
}


/*
// ======================================================================
// system command CLRF - clear game variable to $00
// index of variable to clear is specified in PARAM1
// ======================================================================
*/

void SH_CLRF()
{
	GVARS[PARAM1] = 0x00;
}

/*
// ======================================================================
// system command - SWAP
// swap an item's location with the location of the following item
// item to be swapped is specified in PARAM1
// ======================================================================
*/

void SH_SWAP()
{
	int nTemp = naItemLoc[PARAM1];
	naItemLoc[PARAM1] = naItemLoc[PARAM1 + 1];
	naItemLoc[PARAM1 + 1] = nTemp;
}

/*
// ======================================================================
// system command - DEAD
// immediately terminate game, stop executing system commands
// ======================================================================
*/

void SH_DEAD()
{

	PrintStr("Do you wish to try again?\n");

	for (;;)
	{
		char ch;

		PrintStr("Answer yes or no\n");
		ch = i_GetCh();
		if (ch == 'Y')
		{
			nNextParseAction = NA_RESTART;
			return;
		}
		if (ch == 'N')
		{
			exit(0);
		}
	}
}









/* display "OK.." prompt and cease processing system commands */


void SH_OK()
{
	PrintStr("OK..\n");
	nNextParseAction = NA_DO_AUTO;
}




void SH_QUIT()
{
#ifdef TAPE
	PrintStr("Do you want to save the game?\n");

	if (i_GetCh() == 'Y')
	{
		/* save */
		PrintStr("Start tape, then press a key\n");
		i_GetCh();
		tape_save_block(GVARS, sizeof(GVARS), 1);
#ifdef COMPUTE_SCORE
		tape_save_block(&nScore, sizeof(nScore), 2);
#endif
		tape_save_block(naItemLoc, sizeof(naItemLoc), 3);
		tape_save_block(&CUR_RM, sizeof(CUR_RM), 4);
#endif

#ifdef DISK
	PrintStr("Do you want to save the game?\n");

	if (i_GetCh() == 'Y')
	{
		/* save */
		fpsave=fopen("adv_a.sav","wb");
		fwrite(GVARS, sizeof(GVARS),1, fpsave);
#ifdef COMPUTE_SCORE
		fwrite(&nScore, sizeof(nScore),1, fpsave);
#endif
		fwrite(naItemLoc, sizeof(naItemLoc),1, fpsave);
		fwrite(&CUR_RM, sizeof(CUR_RM),1, fpsave);
		fclose(fpsave);
#endif

		PrintStr("Do you wish to continue?\n");

		if (i_GetCh() == 'Y')
		{
			nNextParseAction = NA_DO_AUTO;
			return;
		}
#ifdef TAPE
	}
#endif
#ifdef DISK
	}
#endif

	SH_DEAD();
}





/*
// ======================================================================
// system command SETV - set game variable to a specific value
// index of variable to set is specified in PARAM1
// the new value is specified as the byte after this command
// ======================================================================
*/

void SH_SETV()
{
	int nParam2 = *++pActionCurrent;
	
	GVARS[PARAM1] = nParam2;
}


/*
// ======================================================================
// system command CREA - create item in current room
// index of item to be created is specified in PARAM1
// ======================================================================
*/

void SH_CREA()
{
	naItemLoc[PARAM1] = CUR_RM;
}


/*
// ======================================================================
// system command DEST - destroy item in current room
// index of item to be destoyed is specified in PARAM1
// ======================================================================
*/

void SH_DEST()
{
	naItemLoc[PARAM1] = NOTX;
}






/* clean-up and abort execution of system commands, continuing with auto commands */

void SH_FAIL()
{
	nNextParseAction = NA_DO_AUTO;
}


/*
// ======================================================================
// system command ADSC - add value to the current score.
// value to be added is specified in PARAM1
// ======================================================================
*/

void SH_ADSC()
{
#ifdef COMPUTE_SCORE
	nScore += PARAM1;
#endif
}

void SH_SCOR()
{
#ifdef COMPUTE_SCORE
	char szScore[32];
	
	PrintStr("You have a score of ");
	
#ifndef printn
	sprintf(szScore, "%04x", nScore);		// hex! (really)
	PrintStr(szScore);
#else
	printn(nScore,16,stdout);
#endif
	PrintCR();
#endif
}	

/* addresses of various system function handlers */

void* SYS_V[] =
{
	SH_INVE,
	SH_REMO,
	SH_GET,
	SH_DROP,
	SH_WEAR,
	SH_MSG,
	SH_REDE,
	SH_AUTO,
	SH_GOTO,
	SH_SETF,
	SH_CLRF,
	SH_SWAP,
	SH_DEAD,
	SH_OK,
	SH_QUIT,
	SH_SETV,
	SH_CREA,
	SH_DEST,
	SH_ADSC,
	SH_SCOR,
	SH_FAIL,
	SH_TELL,
	SH_FAIL,
	SH_FAIL,
	SH_FAIL
};

/*
// ======================================================================
// fetch command token from the input buffer, starting at position HL
// on return, A contains the token code (or $ff if not recognized)
// and HL points to the character after the token
// ======================================================================
*/

int GET_TOK()
{
	char *pchTokenBuffer = strTokenBuf;
	int nResult = 0xff;
	int n;

	strncpy(strTokenBuf, "    ", 4);	/* clear the token buffer to spaces */

	for (n = 0; n < 4; ++n)
	{
		char ch = *pchEditLine;
		if (ch == ' ')
			break;

		if (ch == '\0')
			break;

		if (ch == '\n')
			break;

		*pchTokenBuffer++ = ch;
		++pchEditLine;
	}

	for (n = 0; n < MAX_TOK; ++n)
	{
		if (strncmp(strTokenBuf, taToken[n].strWord, 4) == 0)
		{
			nResult = taToken[n].nCode;
			break;
		}
	}
	
	return nResult;
}


/***



; ======================================================================



LCASS	push    hl
      	jr      LCASS_1                   ; (16)

LCASS_M	.text	"READY CASSETTE"
		.byte	$0d,$00

LCASS_1	ld      hl,LCASS_M
      	call    PrintStr
      	pop     hl
      	call    i_GetCh
      	push    ix
      	ld      ix,FLAG
      	ld      de,$0029
      	ld      a,$ff
        scf     
      	call    ROM_LD
      	ld      ix,naItemLoc
      	ld      de,$001d
      	ld      a,$ff
        scf     
      	call    ROM_LD
      	pop     ix
      	ret     

****/
/*
// ======================================================================
// fetch key from buffer
// waits for keypress, returns ascii code in A
// ======================================================================
*/

char i_GetCh()
{
	int ch;
	
	do
	{
		ch = getkey();
	} while ((ch != '\n') && (ch != '\r') && (ch != KEY_DEL ) && !(ch >= ' ' && ch <= '~'));

	if (ch == '\r')
		ch = '\n';

	if (ch >= 'a' && ch <= 'z')
		ch ^= 0x20;
	
	return (char) ch;
}

/***

		; unused keyboard-reading code (left over from ZX81 version?)

      	push    de
      	ld      d,a
      	ld      a,$7f
        in      a,($fe)
        rra     
      	jr      c,ZX_END2
      	ld      a,$fe
        in      a,($fe)
        rra     
      	jr      c,ZX_END2
      	ld      a,$01
        or      a

ZX_END	ld      a,d
      	pop     de
      	ret     

ZX_END2	xor     a
		jr      ZX_END                   ; (-6)


***/

/*
// ======================================================================
// get a line of input from the user
// store the data in the buffer pointed to by HL
// ======================================================================
*/

void GetLine()
{
	int nPos = 0;
	char ch = 0;

	while (ch != '\n')
	{
		chaEditLine[nPos] = 0;
		ch = i_GetCh();

		if (ch == KEY_DEL )		/* delete */
		{
			if (nPos != 0)
			{
				--nPos;
				i_PutCh(8);
				i_PutCh(' ');
				i_PutCh(8);
			}
		}
		else if (ch != '\n')
		{
			if (nPos == MAX_COL)
			{
				i_PutCh(' ');
				i_PutCh(8);
			}
			else
			{
				i_PutCh(ch);
				chaEditLine[nPos++] = ch;
			}
		}
	}

	i_PutCh('\n');
}

	
/*
// ======================================================================
// clear screen, display instructions and wait for keypress
// ======================================================================
*/

void PrintInstr()
{
	ClearScr();
	PrintStr(strInstructions);
	i_GetCh();
}




/****















****/




/****

; spurious data found in the original game

GARBAGE	.word	$5200,$4c4f,$5220,$004f


		.end
****/




int main()
{
	int n;

	for (;;)		/* restart game loop */
	{
		/* initialize the game variables */
		for (n = 0; n <= 0x1e; ++n)
			GVARS[n] = 0;

#ifdef COMPUTE_SCORE
		nScore = 0;
#endif
		
		PrintInstr();

		/* copy data from naItemStart to naItemLoc at start of game */
		for (n = 0; n < MAX_ITEM; ++n)
			naItemLoc[n] = naItemStart[n];

		CUR_RM = 0;

#ifdef TAPE
		PrintStr("Want to restore a game?\n");
		if (i_GetCh() == 'Y')
		{
			/* restore */
			tape_load_block(GVARS, sizeof(GVARS), 1);
#ifdef COMPUTE_SCORE
			tape_load_block(&nScore, sizeof(nScore), 2);
#endif
			tape_load_block(naItemLoc, sizeof(naItemLoc), 3);
			tape_load_block(&CUR_RM, sizeof(CUR_RM), 4);
		}
#endif

#ifdef DISK
		PrintStr("Want to restore a game?\n");
		if (i_GetCh() == 'Y')
		{
		/* restore */
			fpsave=fopen("adv_a.sav","rb");
			fread(GVARS, sizeof(GVARS),1, fpsave);
#ifdef COMPUTE_SCORE
			fread(&nScore, sizeof(nScore),1, fpsave);
#endif
			fread(naItemLoc, sizeof(naItemLoc),1, fpsave);
			fread(&CUR_RM, sizeof(CUR_RM),1, fpsave);
			fclose(fpsave);
		}
#endif

/*
			PrintStr("Restore not supported\n");
			PrintStr("Press a key");
			i_GetCh();
*/

		for (;;)		/* main loop */
		{
			ClearScr();

			if (GVARS[0] == 0)
			{
      			ShowRoom();
			}
			else
			{
				if (GVARS[3] > 0)
					--GVARS[3];
				
				if (naItemLoc[0] == CUR_RM)
				{
	      			ShowRoom();
				}
				else
				{
					PrintStr("Everything is dark. I can't see.\n");
					if (GVARS[4] > 0)
						--GVARS[4];

					nNextParseAction = NA_DO_AUTO;
				}
			}

			for (;;)		/* parse loop */
			{
				switch (nNextParseAction)
				{
				case NA_DO_AUTO:
					pvndCurrent = AUT_LST;
					break;
				case NA_CONTINUE:
					++pvndCurrent;
					break;
				case NA_MAIN:
				case NA_RESTART:
					goto outer_cont;
					break;
				case NA_BEGIN:
					break;
				default:
					PrintStr("Error\n");
					++pvndCurrent;
					break;
				}

				PARSE_LP();
			}

	outer_cont:
			if (nNextParseAction == NA_RESTART)
				break;
		}
	}

	return 0;
}
