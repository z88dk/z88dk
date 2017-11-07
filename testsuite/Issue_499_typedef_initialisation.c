// Using an instance of a typedef didn't use the const qualifier
// that it was defined with

typedef unsigned int uint16_t;


static const uint16_t  val = 1;


typedef void (*MyInitEnemyFunction)( void *);

extern const MyInitEnemyFunction updatestage4endbossfunctions[];

const MyInitEnemyFunction updatestage4endbossfunctions[] = {
	0,
	0,
	0,
};

const int array[] = { 1, 2, 3};
