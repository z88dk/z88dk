
#define EXTRA_POINTS 100UL
#define EXTRA_POINTS_LEVEL_INCREASE 5UL

static unsigned int points;
static unsigned char level;


int func() 
{
	points+=EXTRA_POINTS+level*EXTRA_POINTS_LEVEL_INCREASE;

}
