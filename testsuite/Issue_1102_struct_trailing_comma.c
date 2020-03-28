// example.c
#define EXAMPLE_SIZE	8

struct level {
	unsigned char	tiles[EXAMPLE_SIZE];
	unsigned char	data1[EXAMPLE_SIZE];
	unsigned char	data2[EXAMPLE_SIZE];
};

#define MAX_LEVELS	3

struct level	level_data[MAX_LEVELS] =
{
	//Level 1
	{
		"\x01\x01\x01\x01\x01\x01\x01",
		"foo",
		"bar!",
	},
	//Level 2
	{
		"\x01\x01\x01\x01\x01\x01\x01",
		"foo",
		"bar!",
	},
	//Level 3
	{
		"\x01\x01\x01\x01\x01\x01\x01",
		"foo",
		"bar!",
	},
};

int 
main()
{
	return 0;
}
