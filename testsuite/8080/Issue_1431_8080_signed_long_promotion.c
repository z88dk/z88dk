
#define EXTRA_POINTS 100L
#define EXTRA_POINTS_LEVEL_INCREASE 5L

static int points;
static char level;


int func()
{
	points+=EXTRA_POINTS+level*EXTRA_POINTS_LEVEL_INCREASE;

}
