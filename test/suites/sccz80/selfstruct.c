#include "test.h"
#include <string.h>

/* Dhrystone Rec_Type. The self-referential member is parsed while the
   tag is still incomplete, so an assignment through it used to copy
   with size -1 (65535 bytes). */

typedef struct record {
    struct record *Ptr_Comp;
    int Discr;
    union {
        struct {
            int Enum_Comp;
            int Int_Comp;
            char Str_Comp[31];
        } var_1;
    } variant;
} Rec, *RecPtr;

static struct {
    Rec dst;
    unsigned char guard[4];
} box;

static Rec src;

struct early *early_p;

struct early {
    struct early *next;
    int v;
    char tail;
};

static struct {
    struct early dst;
    unsigned char guard;
} early_box;

static struct early early_src;

void test_self_struct_assign(void)
{
    int i;

    Assert(sizeof(Rec) == sizeof(*src.Ptr_Comp), "member sizeof");
    Assert(sizeof(struct early) == sizeof(*early_p->next), "forward sizeof");

    memset(&src, 0, sizeof src);
    memset(&box, 0x5A, sizeof box);
    src.Ptr_Comp = &box.dst;
    src.Discr = 3;
    src.variant.var_1.Enum_Comp = 4;
    src.variant.var_1.Int_Comp = 40;
    for (i = 0; i < 31; i++)
        src.variant.var_1.Str_Comp[i] = (char)('A' + (i % 26));

    *src.Ptr_Comp = src;

    Assert(box.dst.Discr == 3, "discr");
    Assert(box.dst.variant.var_1.Int_Comp == 40, "int");
    Assert(box.dst.variant.var_1.Str_Comp[0] == 'A', "str0");
    Assert(box.dst.variant.var_1.Str_Comp[30] == (char)('A' + (30 % 26)), "str30");
    Assert(box.dst.Ptr_Comp == &box.dst, "ptr copied");
    Assert(box.guard[0] == 0x5A && box.guard[1] == 0x5A &&
           box.guard[2] == 0x5A && box.guard[3] == 0x5A, "guard");

    memset(&early_src, 0, sizeof early_src);
    early_box.dst.v = 0;
    early_box.dst.tail = 0;
    early_box.guard = 0xA5;
    early_src.next = &early_box.dst;
    early_src.v = 9;
    early_src.tail = 'Z';
    *early_src.next = early_src;
    Assert(early_box.dst.v == 9, "early v");
    Assert(early_box.dst.tail == 'Z', "early tail");
    Assert(early_box.guard == 0xA5, "early guard");
}

int suite_selfstruct(void)
{
    suite_setup("Self-referential struct assign");
    suite_add_test(test_self_struct_assign);
    return suite_run();
}

int main(int argc, char *argv[])
{
    (void)argc;
    (void)argv;
    exit(suite_selfstruct());
}
