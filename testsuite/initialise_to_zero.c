
struct y {
	long l;
};

struct x {
	double x;
	int a;
	struct y blah[10];
};



static struct x arr[4] = {0};


int func()
{
	static struct x un[10] = {0};
	struct x un2[20] = {0};
}
