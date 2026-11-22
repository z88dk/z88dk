public _BoulderRoll

_BoulderRoll:
	defw _BoulderRoll_DataPtr
	defb SprData_StartPage
	defb 4	; Number of frames
	defb 4	; Max sprites used in a frame
	defb 0	; RefCount
	defw BoulderRoll_0
	defw BoulderRoll_1
	defw BoulderRoll_2
	defw BoulderRoll_3

.BoulderRoll_0
	defw 0	; Sprite data offset (pattern index * 128 bytes)
	defb -16, -31, 32, 32	; Top/left coordinate, width, height
	defb 4, 2	; Number of sprites, Num sprites per row
	defb 0, 0	; attr2 flags (mirror, rotate), attr4 flags (expanded sprites)
	defb 255	; cached pattern index
	defb 255	; cached pattern index
	defb 255	; cached pattern index
	defb 255	; cached pattern index

.BoulderRoll_1
	defw 512	; Sprite data offset (pattern index * 128 bytes)
	defb -16, -31, 32, 32	; Top/left coordinate, width, height
	defb 4, 2	; Number of sprites, Num sprites per row
	defb 0, 0	; attr2 flags (mirror, rotate), attr4 flags (expanded sprites)
	defb 255	; cached pattern index
	defb 255	; cached pattern index
	defb 255	; cached pattern index
	defb 255	; cached pattern index

.BoulderRoll_2
	defw 1024	; Sprite data offset (pattern index * 128 bytes)
	defb -16, -31, 32, 32	; Top/left coordinate, width, height
	defb 4, 2	; Number of sprites, Num sprites per row
	defb 0, 0	; attr2 flags (mirror, rotate), attr4 flags (expanded sprites)
	defb 255	; cached pattern index
	defb 255	; cached pattern index
	defb 255	; cached pattern index
	defb 255	; cached pattern index

.BoulderRoll_3
	defw 1536	; Sprite data offset (pattern index * 128 bytes)
	defb -16, -31, 32, 32	; Top/left coordinate, width, height
	defb 4, 2	; Number of sprites, Num sprites per row
	defb 0, 0	; attr2 flags (mirror, rotate), attr4 flags (expanded sprites)
	defb 255	; cached pattern index
	defb 255	; cached pattern index
	defb 255	; cached pattern index
	defb 255	; cached pattern index

