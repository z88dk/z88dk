#define NUM_ROOMS    4
#define NUM_CHOICES  3

struct room
{
   unsigned char *desc;
   unsigned char leadsTo[NUM_CHOICES];
};

extern unsigned char room0_desc[];
extern unsigned char room1_desc[];
extern unsigned char room2_desc[];
extern unsigned char room3_desc[];

const struct room rooms[NUM_ROOMS] = {
	{ room0_desc, { 1,2,3 } },
	{ room1_desc, { 1,2,3 } },
	{ room2_desc, { 1,2,3 } },
	{ room3_desc, { 0,0,0 } }
};

unsigned char room0_desc[] = "room0\n";

unsigned char room1_desc[] = "room1\n";

unsigned char room2_desc[] = "room2\n";

unsigned char room3_desc[] = "room3\n";
