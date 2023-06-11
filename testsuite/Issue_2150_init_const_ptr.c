struct haha_base_t {
    struct haha_base_t *next;
    int kek2;
};
struct haha_derived_t {
    int kek;
    struct haha_base_t base;
};
static struct haha_derived_t a = {1, {0, 14}};
static int* kek1 = &a.kek;
static struct haha_base_t* kek2 = &a.base;
static int* kek3 = &a.base.kek2;