unsigned char *gpp, *gpp2;
unsigned char gpit, gpjt;
unsigned int gpint;
signed int aux;

unsigned char level;
unsigned char nn;
unsigned char rano;
unsigned int score [2];
unsigned int hi_score;
unsigned char do_level, do_game;
unsigned char game_over;

signed int px [2], py [2];
signed int pcx [2], pcy [2];
signed int pvx [2], pvy [2];
unsigned char pframe [2];
unsigned char ppx [2], ppy [2];
unsigned char plives [2];
unsigned char friends [2];
unsigned char pactive [2];
unsigned char ptx1, ptx2, pty1, pty2;
unsigned char phit, pstop;
unsigned char won [2];
unsigned char who_won;

unsigned char field [768];

unsigned char rx, ry, rmx, rmy;
unsigned char rframe, rframeam;

unsigned char game_mode;

unsigned int player_controller_KEY_LEFT [2];
unsigned int player_controller_KEY_RIGHT [2];
unsigned int player_controller_KEY_UP [2];
unsigned int player_controller_KEY_DOWN [2];

unsigned char menu_choice = 0;

#define PLAYER_MAX_V 128
#define PLAYER_A 4

#define RBASE 8

#define GAME_A 0
#define GAME_B 1

unsigned char tv_system; // 0 = pal, 1 = ntsc
