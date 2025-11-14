# Moggy Master v1.00 by mojontwins
[Original Website](http://www.mojontwins.com/juegos_mojonos/moggy-master/)  
[Website at SMS POWER](http://www.smspower.org/Homebrew/MoggyMaster-SMS)

The source code here consists of everything needed to compile the game and does not include raw binary assets that need conversion to sms-friendly formats using other tools as an intermediate step.  To see everything, visit the link above.

## Story

In the Forest of Canutos, past the snowy peak of Jhijhamabad, located in the Northern Noronstronski, the bolotes from the village of Mu, near Kónrad, were celebrating a big party. The joyful music sounded among the trees, the flavour of the winery and the big feast impregned the ambience, thicker and more tasteful as the night went by.

Lost among the craze, the evil Hibön the sorcerer, the greedy tetrarch from Boro, Goro, Sé and Pa, was about to execute his harmful plot: To achieve a higher magic power, he pretended to use bolote’s vital energy, heavy on rays, lightnings and ectoplasms. He had chosen the best chance: the bolotes, drunk and docile, feeling like never giving up partying, won’t resist at all. Like the legendary Hamelin flute player, he would mislead them to “keep partying elsewhere”, and that was exactly what he did. Forming a huge caravan, the bolotes submissively left the Canutos forest heading to Hibön’s realms.

Moggy, the key figure of all parties, didn’t have a good one that night. Somewhat away from the binge, he was sleeping it off way too soon. The mouthwashes from the Fairies and spiritis were making a mess in his stomach, and his mouth still burned for smoking of all those herbs from around the river, when he got up feeling lost, maybe awaken by the deafening silence which had spread across the whole valey.

Stumbling, and without a complete control upon his moves, he discovered in awe that, in the far, really too much far away, a stooped shape guided the whole population of Mu to a dark horizon. Trying to focus with his reddened eyes, he soon recognized the figure as Hibön. That couldn’t be anything good, so, the best he could, he began a dangerous trip to rescue his friends.

## Instructions

Your goal in each screen is getting each one of your pink friends, avoiding touching the green bushes.

We have added the possibility of 2 players. For this we have invented WAW, who is a friend of Moggy in charge of making music Megadrive games that manufacture in the forest of canutos.

Moggy and WAW each day went to the dodgy part of the forest for walks and rescue some friends and find a Watermelon’s Tico Tico. Only one. It’s a death match. The player who rescue more friends , will be the player who wins the competition.

You can use the Master System Control Pads to control each other. But beware, it ain’t as easy as it looks: the state in which Moggy is at (i.e. he’s drunk!) makes him response in an odd way to your commands. If he is running right at top speed and we press “DOWN”, the acceleration in this direction will be gradual, and the trajectory will descrive a curve. If we want to deccelerate, we have to press the opposite direction so the speed decreases little by little.

## Compiling

sccz80 compile:
~~~
zcc +sms -v -c -clib=new --constsegBANK_02 src/bank2.c -o ./bank2.o
zcc +sms -v -c -clib=new --constsegBANK_03 src/bank3.c -o ./bank3.o
zcc +sms -v -startup=16 -clib=new -O3 src/wtf.c bank2.o bank3.o -o wtf -pragma-include:zpragma.inc -create-app
~~~
zsdcc compile (high optimization means compile time could be long):
~~~
zcc +sms -v -c -clib=sdcc_iy --constsegBANK_02 src/bank2.c -o ./bank2.o
zcc +sms -v -c -clib=sdcc_iy --constsegBANK_03 src/bank3.c -o ./bank3.o
zcc +sms -v -startup=16 -clib=sdcc_iy -SO3 --max-allocs-per-node200000 src/wtf.c bank2.o bank3.o -o wtf -pragma-include:zpragma.inc -create-app
~~~
