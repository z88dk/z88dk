/*
 *      Header for command entries for Topic 3
 *
 *      Do not include yourself - included by application.h
 *
 *      7/4/99 djm
 */


#ifdef TOPIC3_1
.in_com_3_1
        defb    in_com_3_1end - in_com_3_1
        APPLBYTE(TOPIC3_1CODE)
        APPLNAME(TOPIC3_1KEY)
        APPLTEXT(TOPIC3_1)
#ifdef TOPIC3_1HELP1
        defb    (in_com_hlp3_1 - in_help) /256
        defb    (in_com_hlp3_1 - in_help) %256
#else
        defb    0,0               ;pointer to help - use \0
#endif  /* TOPIC3_1HELP1) */
#ifdef TOPIC3_1ATTR
        APPLBYTE(TOPIC3_1ATTR)
#else
        defb    0
#endif /* TOPIC3_1ATTR */
        defb    in_com_3_1end - in_com_3_1
.in_com_3_1end
#endif /* TOPIC3_1 */


#ifdef TOPIC3_2
.in_com_3_2
        defb    in_com_3_2end - in_com_3_2
        APPLBYTE(TOPIC3_2CODE)
        APPLNAME(TOPIC3_2KEY)
        APPLTEXT(TOPIC3_2)
#ifdef TOPIC3_2HELP1
        defb    (in_com_hlp3_2 - in_help) /256
        defb    (in_com_hlp3_2 - in_help) %256
#else
        defb    0,0               ;pointer to help - use \0
#endif  /* TOPIC3_2HELP1) */
#ifdef TOPIC3_2ATTR
        APPLBYTE(TOPIC3_2ATTR)
#else
        defb    0
#endif /* TOPIC3_2ATTR */
        defb    in_com_3_2end - in_com_3_2
.in_com_3_2end
#endif /* TOPIC3_2 */


#ifdef TOPIC3_3
.in_com_3_3
        defb    in_com_3_3end - in_com_3_3
        APPLBYTE(TOPIC3_3CODE)
        APPLNAME(TOPIC3_3KEY)
        APPLNAME(TOPIC3_3)
#ifdef TOPIC3_3HELP1
        defb    (in_com_hlp3_3 - in_help) /256
        defb    (in_com_hlp3_3 - in_help) %256
#else
        defb    0               ;pointer to help - use \0
#endif  /* TOPIC3_3HELP1) */
#ifdef TOPIC3_3ATTR
        APPLBYTE(TOPIC3_3ATTR)
#else
        defb    0
#endif /* TOPIC3_3ATTR */
        defb    in_com_3_3end - in_com_3_3
.in_com_3_3end
#endif /* TOPIC3_3 */


#ifdef TOPIC3_4
.in_com_3_4
        defb    in_com_3_4end - in_com_3_4
        APPLBYTE(TOPIC3_4CODE)
        APPLNAME(TOPIC3_4KEY)
        APPLNAME(TOPIC3_4)
#ifdef TOPIC3_4HELP1
        defb    (in_com_hlp3_4 - in_help) /256
        defb    (in_com_hlp3_4 - in_help) %256
#else
        defb    0               ;pointer to help - use \0
#endif  /* TOPIC3_4HELP1) */
#ifdef TOPIC3_4ATTR
        APPLBYTE(TOPIC3_4ATTR)
#else
        defb    0
#endif /* TOPIC3_4ATTR */
        defb    in_com_3_4end - in_com_3_4
.in_com_3_4end
#endif /* TOPIC3_4 */


#ifdef TOPIC3_5
.in_com_3_5
        defb    in_com_3_5end - in_com_3_5
        APPLBYTE(TOPIC3_5CODE)
        APPLNAME(TOPIC3_5KEY)
        APPLNAME(TOPIC3_5)
#ifdef TOPIC3_5HELP1
        defb    (in_com_hlp3_5 - in_help) /256
        defb    (in_com_hlp3_5 - in_help) %256
#else
        defb    0               ;pointer to help - use \0
#endif  /* TOPIC3_5HELP1) */
#ifdef TOPIC3_5ATTR
        APPLBYTE(TOPIC3_5ATTR)
#else
        defb    0
#endif /* TOPIC3_5ATTR */
        defb    in_com_3_5end - in_com_3_5
.in_com_3_5end
#endif /* TOPIC3_5 */


#ifdef TOPIC3_6
.in_com_3_6
        defb    in_com_3_6end - in_com_3_6
        APPLBYTE(TOPIC3_6CODE)
        APPLNAME(TOPIC3_6KEY)
        APPLNAME(TOPIC3_6)
#ifdef TOPIC3_6HELP1
        defb    (in_com_hlp3_6 - in_help) /256
        defb    (in_com_hlp3_6 - in_help) %256
#else
        defb    0               ;pointer to help - use \0
#endif  /* TOPIC3_6HELP1) */
#ifdef TOPIC3_6ATTR
        APPLBYTE(TOPIC3_6ATTR)
#else
        defb    0
#endif /* TOPIC3_6ATTR */
        defb    in_com_3_6end - in_com_3_6
.in_com_3_6end
#endif /* TOPIC3_6 */


#ifdef TOPIC3_7
.in_com_3_7
        defb    in_com_3_7end - in_com_3_7
        APPLBYTE(TOPIC3_7CODE)
        APPLNAME(TOPIC3_7KEY)
        APPLNAME(TOPIC3_7)
#ifdef TOPIC3_7HELP1
        defb    (in_com_hlp3_7 - in_help) /256
        defb    (in_com_hlp3_7 - in_help) %256
#else
        defb    0               ;pointer to help - use \0
#endif  /* TOPIC3_7HELP1) */
#ifdef TOPIC3_7ATTR
        APPLBYTE(TOPIC3_7ATTR)
#else
        defb    0
#endif /* TOPIC3_7ATTR */
        defb    in_com_3_7end - in_com_3_7
.in_com_3_7end
#endif /* TOPIC3_7 */


#ifdef TOPIC3_8
.in_com_3_8
        defb    in_com_3_8end - in_com_3_8
        APPLBYTE(TOPIC3_8CODE)
        APPLNAME(TOPIC3_8KEY)
        APPLNAME(TOPIC3_8)
#ifdef TOPIC3_8HELP1
        defb    (in_com_hlp3_8 - in_help) /256
        defb    (in_com_hlp3_8 - in_help) %256
#else
        defb    0               ;pointer to help - use \0
#endif  /* TOPIC3_8HELP1) */
#ifdef TOPIC3_8ATTR
        APPLBYTE(TOPIC3_8ATTR)
#else
        defb    0
#endif /* TOPIC3_8ATTR */
        defb    in_com_3_8end - in_com_3_8
.in_com_3_8end
#endif /* TOPIC3_8 */


#ifdef TOPIC3_9
.in_com_3_9
        defb    in_com_3_9end - in_com_3_9
        APPLBYTE(TOPIC3_9CODE)
        APPLNAME(TOPIC3_9KEY)
        APPLNAME(TOPIC3_9)
#ifdef TOPIC3_9HELP1
        defb    (in_com_hlp3_9 - in_help) /256
        defb    (in_com_hlp3_9 - in_help) %256
#else
        defb    0               ;pointer to help - use \0
#endif  /* TOPIC3_9HELP1) */
#ifdef TOPIC3_9ATTR
        APPLBYTE(TOPIC3_9ATTR)
#else
        defb    0
#endif /* TOPIC3_9ATTR */
        defb    in_com_3_9end - in_com_3_9
.in_com_3_9end
#endif /* TOPIC3_9 */


#ifdef TOPIC3_10
.in_com_3_10
        defb    in_com_3_10end - in_com_3_10
        APPLBYTE(TOPIC3_10CODE)
        APPLNAME(TOPIC3_10KEY)
        APPLNAME(TOPIC3_10)
#ifdef TOPIC3_10HELP1
        defb    (in_com_hlp3_10 - in_help) /256
        defb    (in_com_hlp3_10 - in_help) %256
#else
        defb    0               ;pointer to help - use \0
#endif  /* TOPIC3_10HELP1) */
#ifdef TOPIC3_10ATTR
        APPLBYTE(TOPIC3_10ATTR)
#else
        defb    0
#endif /* TOPIC3_10ATTR */
        defb    in_com_3_10end - in_com_3_10
.in_com_3_10end
#endif /* TOPIC3_10 */


#ifdef TOPIC3_11
.in_com_3_11
        defb    in_com_3_11end - in_com_3_11
        APPLBYTE(TOPIC3_11CODE)
        APPLNAME(TOPIC3_11KEY)
        APPLNAME(TOPIC3_11)
#ifdef TOPIC3_11HELP1
        defb    (in_com_hlp3_11 - in_help) /256
        defb    (in_com_hlp3_11 - in_help) %256
#else
        defb    0               ;pointer to help - use \0
#endif  /* TOPIC3_11HELP1) */
#ifdef TOPIC3_11ATTR
        APPLBYTE(TOPIC3_11ATTR)
#else
        defb    0
#endif /* TOPIC3_11ATTR */
        defb    in_com_3_11end - in_com_3_11
.in_com_3_11end
#endif /* TOPIC3_11 */


#ifdef TOPIC3_12
.in_com_3_12
        defb    in_com_3_12end - in_com_3_12
        APPLBYTE(TOPIC3_12CODE)
        APPLNAME(TOPIC3_12KEY)
        APPLNAME(TOPIC3_12)
#ifdef TOPIC3_12HELP1
        defb    (in_com_hlp3_12 - in_help) /256
        defb    (in_com_hlp3_12 - in_help) %256
#else
        defb    0               ;pointer to help - use \0
#endif  /* TOPIC3_12HELP1) */
#ifdef TOPIC3_12ATTR
        APPLBYTE(TOPIC3_12ATTR)
#else
        defb    0
#endif /* TOPIC3_12ATTR */
        defb    in_com_3_12end - in_com_3_12
.in_com_3_12end
#endif /* TOPIC3_12 */


#ifdef TOPIC3_13
.in_com_3_13
        defb    in_com_3_13end - in_com_3_13
        APPLBYTE(TOPIC3_13CODE)
        APPLNAME(TOPIC3_13KEY)
        APPLNAME(TOPIC3_13)
#ifdef TOPIC3_13HELP1
        defb    (in_com_hlp3_13 - in_help) /256
        defb    (in_com_hlp3_13 - in_help) %256
#else
        defb    0               ;pointer to help - use \0
#endif  /* TOPIC3_13HELP1) */
#ifdef TOPIC3_13ATTR
        APPLBYTE(TOPIC3_13ATTR)
#else
        defb    0
#endif /* TOPIC3_13ATTR */
        defb    in_com_3_13end - in_com_3_13
.in_com_3_13end
#endif /* TOPIC3_13 */


#ifdef TOPIC3_14
.in_com_3_14
        defb    in_com_3_14end - in_com_3_14
        APPLBYTE(TOPIC3_14CODE)
        APPLNAME(TOPIC3_14KEY)
        APPLNAME(TOPIC3_14)
#ifdef TOPIC3_14HELP1
        defb    (in_com_hlp3_14 - in_help) /256
        defb    (in_com_hlp3_14 - in_help) %256
#else
        defb    0               ;pointer to help - use \0
#endif  /* TOPIC3_14HELP1) */
#ifdef TOPIC3_14ATTR
        APPLBYTE(TOPIC3_14ATTR)
#else
        defb    0
#endif /* TOPIC3_14ATTR */
        defb    in_com_3_14end - in_com_3_14
.in_com_3_14end
#endif /* TOPIC3_14 */


#ifdef TOPIC3_15
.in_com_3_15
        defb    in_com_3_15end - in_com_3_15
        APPLBYTE(TOPIC3_15CODE)
        APPLNAME(TOPIC3_15KEY)
        APPLNAME(TOPIC3_15)
#ifdef TOPIC3_15HELP1
        defb    (in_com_hlp3_15 - in_help) /256
        defb    (in_com_hlp3_15 - in_help) %256
#else
        defb    0               ;pointer to help - use \0
#endif  /* TOPIC3_15HELP1) */
#ifdef TOPIC3_15ATTR
        APPLBYTE(TOPIC3_15ATTR)
#else
        defb    0
#endif /* TOPIC3_15ATTR */
        defb    in_com_3_15end - in_com_3_15
.in_com_3_15end
#endif /* TOPIC3_15 */


#ifdef TOPIC3_16
.in_com_3_16
        defb    in_com_3_16end - in_com_3_16
        APPLBYTE(TOPIC3_16CODE)
        APPLNAME(TOPIC3_16KEY)
        APPLNAME(TOPIC3_16)
#ifdef TOPIC3_16HELP1
        defb    (in_com_hlp3_16 - in_help) /256
        defb    (in_com_hlp3_16 - in_help) %256
#else
        defb    0               ;pointer to help - use \0
#endif  /* TOPIC3_16HELP1) */
#ifdef TOPIC3_16ATTR
        APPLBYTE(TOPIC3_16ATTR)
#else
        defb    0
#endif /* TOPIC3_16ATTR */
        defb    in_com_3_16end - in_com_3_16
.in_com_3_16end
#endif /* TOPIC3_16 */


#ifdef TOPIC3_17
.in_com_3_17
        defb    in_com_3_17end - in_com_3_17
        APPLBYTE(TOPIC3_17CODE)
        APPLNAME(TOPIC3_17KEY)
        APPLNAME(TOPIC3_17)
#ifdef TOPIC3_17HELP1
        defb    (in_com_hlp3_17 - in_help) /256
        defb    (in_com_hlp3_17 - in_help) %256
#else
        defb    0               ;pointer to help - use \0
#endif  /* TOPIC3_17HELP1) */
#ifdef TOPIC3_17ATTR
        APPLBYTE(TOPIC3_17ATTR)
#else
        defb    0
#endif /* TOPIC3_17ATTR */
        defb    in_com_3_17end - in_com_3_17
.in_com_3_17end
#endif /* TOPIC3_17 */


#ifdef TOPIC3_18
.in_com_3_18
        defb    in_com_3_18end - in_com_3_18
        APPLBYTE(TOPIC3_18CODE)
        APPLNAME(TOPIC3_18KEY)
        APPLNAME(TOPIC3_18)
#ifdef TOPIC3_18HELP1
        defb    (in_com_hlp3_18 - in_help) /256
        defb    (in_com_hlp3_18 - in_help) %256
#else
        defb    0               ;pointer to help - use \0
#endif  /* TOPIC3_18HELP1) */
#ifdef TOPIC3_18ATTR
        APPLBYTE(TOPIC3_18ATTR)
#else
        defb    0
#endif /* TOPIC3_18ATTR */
        defb    in_com_3_18end - in_com_3_18
.in_com_3_18end
#endif /* TOPIC3_18 */


#ifdef TOPIC3_19
.in_com_3_19
        defb    in_com_3_19end - in_com_3_19
        APPLBYTE(TOPIC3_19CODE)
        APPLNAME(TOPIC3_19KEY)
        APPLNAME(TOPIC3_19)
#ifdef TOPIC3_19HELP1
        defb    (in_com_hlp3_19 - in_help) /256
        defb    (in_com_hlp3_19 - in_help) %256
#else
        defb    0               ;pointer to help - use \0
#endif  /* TOPIC3_19HELP1) */
#ifdef TOPIC3_19ATTR
        APPLBYTE(TOPIC3_19ATTR)
#else
        defb    0
#endif /* TOPIC3_19ATTR */
        defb    in_com_3_19end - in_com_3_19
.in_com_3_19end
#endif /* TOPIC3_19 */


#ifdef TOPIC3_20
.in_com_3_20
        defb    in_com_3_20end - in_com_3_20
        APPLBYTE(TOPIC3_20CODE)
        APPLNAME(TOPIC3_20KEY)
        APPLNAME(TOPIC3_20)
#ifdef TOPIC3_20HELP1
        defb    (in_com_hlp3_20 - in_help) /256
        defb    (in_com_hlp3_20 - in_help) %256
#else
        defb    0               ;pointer to help - use \0
#endif  /* TOPIC3_20HELP1) */
#ifdef TOPIC3_20ATTR
        APPLBYTE(TOPIC3_20ATTR)
#else
        defb    0
#endif /* TOPIC3_20ATTR */
        defb    in_com_3_20end - in_com_3_20
.in_com_3_20end
#endif /* TOPIC3_20 */


#ifdef TOPIC3_21
.in_com_3_21
        defb    in_com_3_21end - in_com_3_21
        APPLBYTE(TOPIC3_21CODE)
        APPLNAME(TOPIC3_21KEY)
        APPLNAME(TOPIC3_21)
#ifdef TOPIC3_21HELP1
        defb    (in_com_hlp3_21 - in_help) /256
        defb    (in_com_hlp3_21 - in_help) %256
#else
        defb    0               ;pointer to help - use \0
#endif  /* TOPIC3_21HELP1) */
#ifdef TOPIC3_21ATTR
        APPLBYTE(TOPIC3_21ATTR)
#else
        defb    0
#endif /* TOPIC3_21ATTR */
        defb    in_com_3_21end - in_com_3_21
.in_com_3_21end
#endif /* TOPIC3_21 */


#ifdef TOPIC3_22
.in_com_3_22
        defb    in_com_3_22end - in_com_3_22
        APPLBYTE(TOPIC3_22CODE)
        APPLNAME(TOPIC3_22KEY)
        APPLNAME(TOPIC3_22)
#ifdef TOPIC3_22HELP1
        defb    (in_com_hlp3_22 - in_help) /256
        defb    (in_com_hlp3_22 - in_help) %256
#else
        defb    0               ;pointer to help - use \0
#endif  /* TOPIC3_22HELP1) */
#ifdef TOPIC3_22ATTR
        APPLBYTE(TOPIC3_22ATTR)
#else
        defb    0
#endif /* TOPIC3_22ATTR */
        defb    in_com_3_22end - in_com_3_22
.in_com_3_22end
#endif /* TOPIC3_22 */


#ifdef TOPIC3_23
.in_com_3_23
        defb    in_com_3_23end - in_com_3_23
        APPLBYTE(TOPIC3_23CODE)
        APPLNAME(TOPIC3_23KEY)
        APPLNAME(TOPIC3_23)
#ifdef TOPIC3_23HELP1
        defb    (in_com_hlp3_23 - in_help) /256
        defb    (in_com_hlp3_23 - in_help) %256
#else
        defb    0               ;pointer to help - use \0
#endif  /* TOPIC3_23HELP1) */
#ifdef TOPIC3_23ATTR
        APPLBYTE(TOPIC3_23ATTR)
#else
        defb    0
#endif /* TOPIC3_23ATTR */
        defb    in_com_3_23end - in_com_3_23
.in_com_3_23end
#endif /* TOPIC3_23 */


#ifdef TOPIC3_24
.in_com_3_24
        defb    in_com_3_24end - in_com_3_24
        APPLBYTE(TOPIC3_24CODE)
        APPLNAME(TOPIC3_24KEY)
        APPLNAME(TOPIC3_24)
#ifdef TOPIC3_24HELP1
        defb    (in_com_hlp3_24 - in_help) /256
        defb    (in_com_hlp3_24 - in_help) %256
#else
        defb    0               ;pointer to help - use \0
#endif  /* TOPIC3_24HELP1) */
#ifdef TOPIC3_24ATTR
        APPLBYTE(TOPIC3_24ATTR)
#else
        defb    0
#endif /* TOPIC3_24ATTR */
        defb    in_com_3_24end - in_com_3_24
.in_com_3_24end
#endif /* TOPIC3_24 */

/*
 * If we have the first item of next topic, then we carry on!
 */

#ifdef TOPIC4_1
        defb    1               ;end marker of current topic
#endif
