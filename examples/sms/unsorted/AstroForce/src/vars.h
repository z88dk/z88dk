// Keyboard
unsigned int keystatus;  		// Estado del teclado

// Frames in stage
unsigned int stageframe; 		// Guarda las frames en una stage

// Speeding thins up
unsigned char stageframe2mod;
unsigned char stageframe4mod;
unsigned char sprite82anim;
unsigned char sprite164anim;

// Game vars
unsigned char basestage;					// Base stage para las 4 primeras fases
unsigned char playstage;					// Stage que se esta jugando en playstage
unsigned char updateplaystage;				// Si hay que hacer el update de la stage
unsigned char stagenum; 					// Numero de fase (del orden de la partida)
unsigned char laststagenum;					// Ultima stage, para el continue
unsigned char numplayers;					// Numero de players
unsigned char exitplaystage;				// Flag para salir de la stage
unsigned char gamelevel;					// Dificultad del juego
unsigned char gamestock;					// Número de jugadores por defecto
unsigned char gamepause;					// Si hay pausa

// Player
#define DEFAULTPLAYERSPEED 2
#define ENEMYSHOOTDENSITY 4

unsigned char playerx;				// Posicion X del jugador
unsigned char playery;				// Posicion Y del jugador
unsigned char playertype;			// Estado del player
unsigned char playercounter;		// Contador util para timers
unsigned char playershootcounter; 	// Contador para shoots
unsigned char playerside;			// Side of player sprite
unsigned char playerspeed;			// Player speed
unsigned char playershootlevel; 	// Player shoot level
unsigned char playershootmax;		// Player shoot max

#define PLAYERSHOOT_SIDE_LEFT 0
#define PLAYERSHOOT_NORMAL 1
#define PLAYERSHOOT_SIDE_RIGHT 3

#define PLAYERSHOOTINTERVAL_NORMAL 3
#define PLAYERSHOOTINTERVAL_SIDE 6

#define MAXPLAYERSHOOTS 3
unsigned char numplayershoots;					// Disparos actuales
typedef struct playershoot
{
	unsigned char playershootx;
	unsigned char playershooty;
	unsigned char playershoottype;
	signed char playershootvelx;
	unsigned char playershootvely;
}playershoot;
playershoot playershoots[MAXPLAYERSHOOTS];

// Disparos de enemigos
#define ENEMYSHOOT_NORMAL 2
#define ENEMYSHOOT_LASER 3

#define MAXENEMYSHOOTS 10
unsigned char shootcount;						// Lleva la cuenta de disparos... sirve para diferenciar entre hard y easy
unsigned char numenemyshoots;					// Disparos actuales
typedef struct enemyshoot
{
	unsigned char enemyshootposx;
	unsigned char enemyshootposy;
	signed char enemyshootvelx;	
	signed char enemyshootvely;	
	unsigned char enemyshoottype;	
}enemyshoot;
enemyshoot enemyshoots[MAXENEMYSHOOTS];
unsigned char playstageshootspeed;

// Explosiones
#define MAXEXPLOSIONS 10
unsigned char numexplosions;
typedef struct explosion
{
	unsigned char explosionposx;
	unsigned char explosionposy;
	unsigned char explosionsprite;
	unsigned char explosiontype;
}explosion;
explosion explosions[MAXEXPLOSIONS];

#define MAXENEMIES 10
unsigned char numenemies;
enemy enemies[MAXENEMIES];

// The tilemap
unsigned char *maplines;				// Lineas de un tilemap
unsigned int maplineslength;			// Numero de lineas de un tilemap
unsigned char *maptiles;				// Tiles de un tilemap, en lineas
unsigned int mappositionx;				// Posicion del map
signed int mappositiony;				// Posicion del map
signed int oldmappositiony;			// Antigua posicion del map

// Bank changer
unsigned char lastbank;

// Map statics
const unsigned int *mapstatics;
unsigned int mapstaticscount;
unsigned char mapstaticsbank;

// Music
unsigned char musicbank;

// Map
unsigned char mapbank;

// Playstage
unsigned char playstagebank;

// Scroller
unsigned char numscrolls;
signed char scrollactspeedy;
signed char scrollactspeedx;
unsigned char scrollact;
unsigned int scrolltimes;
unsigned char disablescroll;

typedef struct scroll
{
	signed int scrolllock;
	signed int scrolltimes;
	signed int scrolljump;
	signed int scrollspeedx;
	signed int scrollspeedy;
}scroll;

scroll *scrolls;


// Scripter
#define MAXSCRIPTS 4
unsigned char numscripts;
typedef struct script
{
	unsigned int scripterpass;
	unsigned char *scripterscript;
	unsigned char **scripterlabels;
	unsigned char scripterframe;
	signed char scripterloop;
}script;
script scripts[MAXSCRIPTS];

// Labels
#define MAXTIMEREDLABELS 3
unsigned char numtimeredlabels;					// Labels actuales

typedef struct timeredlabel
{
unsigned char timeredlabely;	// Posicion Y de una label
unsigned char timeredlabelt;	// Tiempo final de una label
}timeredlabel;
timeredlabel timeredlabels[MAXTIMEREDLABELS];


// Usado en intro2 y ending
signed int introstageposx;
signed int introstagevelx;

// Enter jukebox?
unsigned char dojukebox;

// Spawned explosion
unsigned char spawnedexplosionposx;
unsigned char spawnedexplosionposy;
unsigned char spawnedexplosionwidth;
unsigned char spawnedexplosionheight;
unsigned char spawnedexplosiontime;

// Check if play rays in stage 4
unsigned char stage4playrays;

// Black magic
unsigned char numinterrupts;

// Powerup
unsigned char powerupx;
unsigned char powerupy;
unsigned char powerupt;
signed char powerupv;
unsigned int powerupcounter;

// Pause music system
char *lastplayedmusic;
unsigned char lastplayedmusicbank;
unsigned char lastplayedmusiclooped;

// Needed in stage 8
unsigned char stage8phase;