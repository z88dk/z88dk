
#include <stdint.h>

enum ForwardDecl;

enum ForwardDecl {
	VALUE1 = 1,
	VALUE2,
};

typedef enum eNoteEdit
{
   EDIT_NONE,
   EDIT_START_TIME,
   EDIT_POS,
   EDIT_DURATION,
} ENoteEdit;

ENoteEdit g_noteEditMode = EDIT_NONE;

typedef struct
{
   uint8_t     note;    // 0-127
   uint8_t     dur;     // 0-32
   uint8_t     time;    // 0-32
   uint8_t     vel;     // 0-15
} EditDataNoteStep;

typedef struct
{
   uint8_t        index;
   EditDataNoteStep  notestep;
   EditDataNoteStep  *notestep2;
} SelectedEditDataNoteStep;

extern SelectedEditDataNoteStep* editedNoteStep;

int main(void)
{
   EditDataNoteStep* editDataNoteStep;
   
   g_noteEditMode = EDIT_DURATION;
   editDataNoteStep = &editedNoteStep->notestep;
   editDataNoteStep = editedNoteStep->notestep2;
   return 1;
}

