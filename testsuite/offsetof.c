

#include <stddef.h>

struct x {
   long table1[20];
   double tablen[10];
};

typedef struct x xt;

static struct x data;


long offs_x = offsetof(struct x, tablen);
long offs_x2 = offsetof(x, tablen);


int offs_xt = offsetof(xt, tablen);

int offs_data = offsetof(data, tablen);

int size_x = sizeof(data);
int size_x_tn = sizeof(data.tablen);

void func()
{
long offs_x = offsetof(struct x, tablen);
long offs_x2 = offsetof(x, tablen);
int offs_xt = offsetof(xt, tablen);
int offs_data = offsetof(data, tablen);

}
