struct {
  int a;
  union {
    int b;
    float c;
  };
  int d;
} foo;

struct {
  int a;
  struct {
    int c;
    int d;
  };
} bar;


int func()
{
	foo.b = 1;
	bar.d = 2;
}

