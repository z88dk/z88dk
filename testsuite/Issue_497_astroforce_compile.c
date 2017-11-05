
extern const const unsigned char *spawners[];

typedef void (*MyInitEnemyFunction)( void *);

extern MyInitEnemyFunction updateintro3objectfunctions[];


int func()
{
	int val;

	(*(updateintro3objectfunctions[val]))(0);
}
