#define NULL (void *)0

struct group
{
char name[20];
struct character* characters[8];

};

struct room
{
char desc[33];
char desc2[33];
struct group* groups[4];
struct room* exits;
int i;
};


int func1()
{
        struct room r;

        r.i = 20;
        r.groups[1] = NULL;
}

int func2()
{
        struct room *r;

        r->i = 20;
        r->groups[1] = NULL;
}
