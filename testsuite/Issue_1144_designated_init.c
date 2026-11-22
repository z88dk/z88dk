

struct test {
        int     x;
        int     y;
        int     z:2;
	int     a:4;
        char    *str;
};


struct test data = { .z = 1, .str = "hello" };
struct test data1 = { .x = 10, .z=1, .a=4, .str = "hello" };
struct test data2 = { .x = 12,  .str = "hello" };


