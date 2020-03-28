
#define INK_RED 2
#define TEAMREQUEST 0xc9
#define INK_BLACK 0

extern void zx_border(int);
extern void sendMsg (int);
unsigned char sendbuf[10];

typedef unsigned char uchar;

int sendJoinTeam(uchar team) {
    zx_border(INK_RED);
    sendbuf[0]=TEAMREQUEST;
    sendbuf[1]=team;
    zx_border(INK_BLACK);
    return sendMsg(2);
}
