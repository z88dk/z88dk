/*
 *      Header for command entries for Topic 6
 *
 *      Do not include yourself - included by application.h
 *
 *      7/4/99 djm
 */


#ifdef TOPIC6_1
.in_com_6_1
        defb    in_com_6_1end - in_com_6_1
        APPLBYTE(TOPIC6_1CODE)
        APPLNAME(TOPIC6_1KEY)
        APPLTEXT(TOPIC6_1)
#ifdef TOPIC6_1HELP1
        defb    (in_com_hlp6_1 - in_help) /256
        defb    (in_com_hlp6_1 - in_help) %256
#else
        defb    0,0               ;pointer to help - use \0
#endif  /* TOPIC6_1HELP1) */
#ifdef TOPIC6_1ATTR
        APPLBYTE(TOPIC6_1ATTR)
#else
        defb    0
#endif /* TOPIC6_1ATTR */
        defb    in_com_6_1end - in_com_6_1
.in_com_6_1end
#endif /* TOPIC6_1 */


#ifdef TOPIC6_2
.in_com_6_2
        defb    in_com_6_2end - in_com_6_2
        APPLBYTE(TOPIC6_2CODE)
        APPLNAME(TOPIC6_2KEY)
        APPLTEXT(TOPIC6_2)
#ifdef TOPIC6_2HELP1
        defb    (in_com_hlp6_2 - in_help) /256
        defb    (in_com_hlp6_2 - in_help) %256
#else
        defb    0,0               ;pointer to help - use \0
#endif  /* TOPIC6_2HELP1) */
#ifdef TOPIC6_2ATTR
        APPLBYTE(TOPIC6_2ATTR)
#else
        defb    0
#endif /* TOPIC6_2ATTR */
        defb    in_com_6_2end - in_com_6_2
.in_com_6_2end
#endif /* TOPIC6_2 */


#ifdef TOPIC6_3
.in_com_6_3
        defb    in_com_6_3end - in_com_6_3
        APPLBYTE(TOPIC6_3CODE)
        APPLNAME(TOPIC6_3KEY)
        APPLNAME(TOPIC6_3)
#ifdef TOPIC6_3HELP1
        defb    (in_com_hlp6_3 - in_help) /256
        defb    (in_com_hlp6_3 - in_help) %256
#else
        defb    0               ;pointer to help - use \0
#endif  /* TOPIC6_3HELP1) */
#ifdef TOPIC6_3ATTR
        APPLBYTE(TOPIC6_3ATTR)
#else
        defb    0
#endif /* TOPIC6_3ATTR */
        defb    in_com_6_3end - in_com_6_3
.in_com_6_3end
#endif /* TOPIC6_3 */


#ifdef TOPIC6_4
.in_com_6_4
        defb    in_com_6_4end - in_com_6_4
        APPLBYTE(TOPIC6_4CODE)
        APPLNAME(TOPIC6_4KEY)
        APPLNAME(TOPIC6_4)
#ifdef TOPIC6_4HELP1
        defb    (in_com_hlp6_4 - in_help) /256
        defb    (in_com_hlp6_4 - in_help) %256
#else
        defb    0               ;pointer to help - use \0
#endif  /* TOPIC6_4HELP1) */
#ifdef TOPIC6_4ATTR
        APPLBYTE(TOPIC6_4ATTR)
#else
        defb    0
#endif /* TOPIC6_4ATTR */
        defb    in_com_6_4end - in_com_6_4
.in_com_6_4end
#endif /* TOPIC6_4 */


#ifdef TOPIC6_5
.in_com_6_5
        defb    in_com_6_5end - in_com_6_5
        APPLBYTE(TOPIC6_5CODE)
        APPLNAME(TOPIC6_5KEY)
        APPLNAME(TOPIC6_5)
#ifdef TOPIC6_5HELP1
        defb    (in_com_hlp6_5 - in_help) /256
        defb    (in_com_hlp6_5 - in_help) %256
#else
        defb    0               ;pointer to help - use \0
#endif  /* TOPIC6_5HELP1) */
#ifdef TOPIC6_5ATTR
        APPLBYTE(TOPIC6_5ATTR)
#else
        defb    0
#endif /* TOPIC6_5ATTR */
        defb    in_com_6_5end - in_com_6_5
.in_com_6_5end
#endif /* TOPIC6_5 */


#ifdef TOPIC6_6
.in_com_6_6
        defb    in_com_6_6end - in_com_6_6
        APPLBYTE(TOPIC6_6CODE)
        APPLNAME(TOPIC6_6KEY)
        APPLNAME(TOPIC6_6)
#ifdef TOPIC6_6HELP1
        defb    (in_com_hlp6_6 - in_help) /256
        defb    (in_com_hlp6_6 - in_help) %256
#else
        defb    0               ;pointer to help - use \0
#endif  /* TOPIC6_6HELP1) */
#ifdef TOPIC6_6ATTR
        APPLBYTE(TOPIC6_6ATTR)
#else
        defb    0
#endif /* TOPIC6_6ATTR */
        defb    in_com_6_6end - in_com_6_6
.in_com_6_6end
#endif /* TOPIC6_6 */


#ifdef TOPIC6_7
.in_com_6_7
        defb    in_com_6_7end - in_com_6_7
        APPLBYTE(TOPIC6_7CODE)
        APPLNAME(TOPIC6_7KEY)
        APPLNAME(TOPIC6_7)
#ifdef TOPIC6_7HELP1
        defb    (in_com_hlp6_7 - in_help) /256
        defb    (in_com_hlp6_7 - in_help) %256
#else
        defb    0               ;pointer to help - use \0
#endif  /* TOPIC6_7HELP1) */
#ifdef TOPIC6_7ATTR
        APPLBYTE(TOPIC6_7ATTR)
#else
        defb    0
#endif /* TOPIC6_7ATTR */
        defb    in_com_6_7end - in_com_6_7
.in_com_6_7end
#endif /* TOPIC6_7 */


#ifdef TOPIC6_8
.in_com_6_8
        defb    in_com_6_8end - in_com_6_8
        APPLBYTE(TOPIC6_8CODE)
        APPLNAME(TOPIC6_8KEY)
        APPLNAME(TOPIC6_8)
#ifdef TOPIC6_8HELP1
        defb    (in_com_hlp6_8 - in_help) /256
        defb    (in_com_hlp6_8 - in_help) %256
#else
        defb    0               ;pointer to help - use \0
#endif  /* TOPIC6_8HELP1) */
#ifdef TOPIC6_8ATTR
        APPLBYTE(TOPIC6_8ATTR)
#else
        defb    0
#endif /* TOPIC6_8ATTR */
        defb    in_com_6_8end - in_com_6_8
.in_com_6_8end
#endif /* TOPIC6_8 */


#ifdef TOPIC6_9
.in_com_6_9
        defb    in_com_6_9end - in_com_6_9
        APPLBYTE(TOPIC6_9CODE)
        APPLNAME(TOPIC6_9KEY)
        APPLNAME(TOPIC6_9)
#ifdef TOPIC6_9HELP1
        defb    (in_com_hlp6_9 - in_help) /256
        defb    (in_com_hlp6_9 - in_help) %256
#else
        defb    0               ;pointer to help - use \0
#endif  /* TOPIC6_9HELP1) */
#ifdef TOPIC6_9ATTR
        APPLBYTE(TOPIC6_9ATTR)
#else
        defb    0
#endif /* TOPIC6_9ATTR */
        defb    in_com_6_9end - in_com_6_9
.in_com_6_9end
#endif /* TOPIC6_9 */


#ifdef TOPIC6_10
.in_com_6_10
        defb    in_com_6_10end - in_com_6_10
        APPLBYTE(TOPIC6_10CODE)
        APPLNAME(TOPIC6_10KEY)
        APPLNAME(TOPIC6_10)
#ifdef TOPIC6_10HELP1
        defb    (in_com_hlp6_10 - in_help) /256
        defb    (in_com_hlp6_10 - in_help) %256
#else
        defb    0               ;pointer to help - use \0
#endif  /* TOPIC6_10HELP1) */
#ifdef TOPIC6_10ATTR
        APPLBYTE(TOPIC6_10ATTR)
#else
        defb    0
#endif /* TOPIC6_10ATTR */
        defb    in_com_6_10end - in_com_6_10
.in_com_6_10end
#endif /* TOPIC6_10 */


#ifdef TOPIC6_11
.in_com_6_11
        defb    in_com_6_11end - in_com_6_11
        APPLBYTE(TOPIC6_11CODE)
        APPLNAME(TOPIC6_11KEY)
        APPLNAME(TOPIC6_11)
#ifdef TOPIC6_11HELP1
        defb    (in_com_hlp6_11 - in_help) /256
        defb    (in_com_hlp6_11 - in_help) %256
#else
        defb    0               ;pointer to help - use \0
#endif  /* TOPIC6_11HELP1) */
#ifdef TOPIC6_11ATTR
        APPLBYTE(TOPIC6_11ATTR)
#else
        defb    0
#endif /* TOPIC6_11ATTR */
        defb    in_com_6_11end - in_com_6_11
.in_com_6_11end
#endif /* TOPIC6_11 */


#ifdef TOPIC6_12
.in_com_6_12
        defb    in_com_6_12end - in_com_6_12
        APPLBYTE(TOPIC6_12CODE)
        APPLNAME(TOPIC6_12KEY)
        APPLNAME(TOPIC6_12)
#ifdef TOPIC6_12HELP1
        defb    (in_com_hlp6_12 - in_help) /256
        defb    (in_com_hlp6_12 - in_help) %256
#else
        defb    0               ;pointer to help - use \0
#endif  /* TOPIC6_12HELP1) */
#ifdef TOPIC6_12ATTR
        APPLBYTE(TOPIC6_12ATTR)
#else
        defb    0
#endif /* TOPIC6_12ATTR */
        defb    in_com_6_12end - in_com_6_12
.in_com_6_12end
#endif /* TOPIC6_12 */


#ifdef TOPIC6_13
.in_com_6_13
        defb    in_com_6_13end - in_com_6_13
        APPLBYTE(TOPIC6_13CODE)
        APPLNAME(TOPIC6_13KEY)
        APPLNAME(TOPIC6_13)
#ifdef TOPIC6_13HELP1
        defb    (in_com_hlp6_13 - in_help) /256
        defb    (in_com_hlp6_13 - in_help) %256
#else
        defb    0               ;pointer to help - use \0
#endif  /* TOPIC6_13HELP1) */
#ifdef TOPIC6_13ATTR
        APPLBYTE(TOPIC6_13ATTR)
#else
        defb    0
#endif /* TOPIC6_13ATTR */
        defb    in_com_6_13end - in_com_6_13
.in_com_6_13end
#endif /* TOPIC6_13 */


#ifdef TOPIC6_14
.in_com_6_14
        defb    in_com_6_14end - in_com_6_14
        APPLBYTE(TOPIC6_14CODE)
        APPLNAME(TOPIC6_14KEY)
        APPLNAME(TOPIC6_14)
#ifdef TOPIC6_14HELP1
        defb    (in_com_hlp6_14 - in_help) /256
        defb    (in_com_hlp6_14 - in_help) %256
#else
        defb    0               ;pointer to help - use \0
#endif  /* TOPIC6_14HELP1) */
#ifdef TOPIC6_14ATTR
        APPLBYTE(TOPIC6_14ATTR)
#else
        defb    0
#endif /* TOPIC6_14ATTR */
        defb    in_com_6_14end - in_com_6_14
.in_com_6_14end
#endif /* TOPIC6_14 */


#ifdef TOPIC6_15
.in_com_6_15
        defb    in_com_6_15end - in_com_6_15
        APPLBYTE(TOPIC6_15CODE)
        APPLNAME(TOPIC6_15KEY)
        APPLNAME(TOPIC6_15)
#ifdef TOPIC6_15HELP1
        defb    (in_com_hlp6_15 - in_help) /256
        defb    (in_com_hlp6_15 - in_help) %256
#else
        defb    0               ;pointer to help - use \0
#endif  /* TOPIC6_15HELP1) */
#ifdef TOPIC6_15ATTR
        APPLBYTE(TOPIC6_15ATTR)
#else
        defb    0
#endif /* TOPIC6_15ATTR */
        defb    in_com_6_15end - in_com_6_15
.in_com_6_15end
#endif /* TOPIC6_15 */


#ifdef TOPIC6_16
.in_com_6_16
        defb    in_com_6_16end - in_com_6_16
        APPLBYTE(TOPIC6_16CODE)
        APPLNAME(TOPIC6_16KEY)
        APPLNAME(TOPIC6_16)
#ifdef TOPIC6_16HELP1
        defb    (in_com_hlp6_16 - in_help) /256
        defb    (in_com_hlp6_16 - in_help) %256
#else
        defb    0               ;pointer to help - use \0
#endif  /* TOPIC6_16HELP1) */
#ifdef TOPIC6_16ATTR
        APPLBYTE(TOPIC6_16ATTR)
#else
        defb    0
#endif /* TOPIC6_16ATTR */
        defb    in_com_6_16end - in_com_6_16
.in_com_6_16end
#endif /* TOPIC6_16 */


#ifdef TOPIC6_17
.in_com_6_17
        defb    in_com_6_17end - in_com_6_17
        APPLBYTE(TOPIC6_17CODE)
        APPLNAME(TOPIC6_17KEY)
        APPLNAME(TOPIC6_17)
#ifdef TOPIC6_17HELP1
        defb    (in_com_hlp6_17 - in_help) /256
        defb    (in_com_hlp6_17 - in_help) %256
#else
        defb    0               ;pointer to help - use \0
#endif  /* TOPIC6_17HELP1) */
#ifdef TOPIC6_17ATTR
        APPLBYTE(TOPIC6_17ATTR)
#else
        defb    0
#endif /* TOPIC6_17ATTR */
        defb    in_com_6_17end - in_com_6_17
.in_com_6_17end
#endif /* TOPIC6_17 */


#ifdef TOPIC6_18
.in_com_6_18
        defb    in_com_6_18end - in_com_6_18
        APPLBYTE(TOPIC6_18CODE)
        APPLNAME(TOPIC6_18KEY)
        APPLNAME(TOPIC6_18)
#ifdef TOPIC6_18HELP1
        defb    (in_com_hlp6_18 - in_help) /256
        defb    (in_com_hlp6_18 - in_help) %256
#else
        defb    0               ;pointer to help - use \0
#endif  /* TOPIC6_18HELP1) */
#ifdef TOPIC6_18ATTR
        APPLBYTE(TOPIC6_18ATTR)
#else
        defb    0
#endif /* TOPIC6_18ATTR */
        defb    in_com_6_18end - in_com_6_18
.in_com_6_18end
#endif /* TOPIC6_18 */


#ifdef TOPIC6_19
.in_com_6_19
        defb    in_com_6_19end - in_com_6_19
        APPLBYTE(TOPIC6_19CODE)
        APPLNAME(TOPIC6_19KEY)
        APPLNAME(TOPIC6_19)
#ifdef TOPIC6_19HELP1
        defb    (in_com_hlp6_19 - in_help) /256
        defb    (in_com_hlp6_19 - in_help) %256
#else
        defb    0               ;pointer to help - use \0
#endif  /* TOPIC6_19HELP1) */
#ifdef TOPIC6_19ATTR
        APPLBYTE(TOPIC6_19ATTR)
#else
        defb    0
#endif /* TOPIC6_19ATTR */
        defb    in_com_6_19end - in_com_6_19
.in_com_6_19end
#endif /* TOPIC6_19 */


#ifdef TOPIC6_20
.in_com_6_20
        defb    in_com_6_20end - in_com_6_20
        APPLBYTE(TOPIC6_20CODE)
        APPLNAME(TOPIC6_20KEY)
        APPLNAME(TOPIC6_20)
#ifdef TOPIC6_20HELP1
        defb    (in_com_hlp6_20 - in_help) /256
        defb    (in_com_hlp6_20 - in_help) %256
#else
        defb    0               ;pointer to help - use \0
#endif  /* TOPIC6_20HELP1) */
#ifdef TOPIC6_20ATTR
        APPLBYTE(TOPIC6_20ATTR)
#else
        defb    0
#endif /* TOPIC6_20ATTR */
        defb    in_com_6_20end - in_com_6_20
.in_com_6_20end
#endif /* TOPIC6_20 */


#ifdef TOPIC6_21
.in_com_6_21
        defb    in_com_6_21end - in_com_6_21
        APPLBYTE(TOPIC6_21CODE)
        APPLNAME(TOPIC6_21KEY)
        APPLNAME(TOPIC6_21)
#ifdef TOPIC6_21HELP1
        defb    (in_com_hlp6_21 - in_help) /256
        defb    (in_com_hlp6_21 - in_help) %256
#else
        defb    0               ;pointer to help - use \0
#endif  /* TOPIC6_21HELP1) */
#ifdef TOPIC6_21ATTR
        APPLBYTE(TOPIC6_21ATTR)
#else
        defb    0
#endif /* TOPIC6_21ATTR */
        defb    in_com_6_21end - in_com_6_21
.in_com_6_21end
#endif /* TOPIC6_21 */


#ifdef TOPIC6_22
.in_com_6_22
        defb    in_com_6_22end - in_com_6_22
        APPLBYTE(TOPIC6_22CODE)
        APPLNAME(TOPIC6_22KEY)
        APPLNAME(TOPIC6_22)
#ifdef TOPIC6_22HELP1
        defb    (in_com_hlp6_22 - in_help) /256
        defb    (in_com_hlp6_22 - in_help) %256
#else
        defb    0               ;pointer to help - use \0
#endif  /* TOPIC6_22HELP1) */
#ifdef TOPIC6_22ATTR
        APPLBYTE(TOPIC6_22ATTR)
#else
        defb    0
#endif /* TOPIC6_22ATTR */
        defb    in_com_6_22end - in_com_6_22
.in_com_6_22end
#endif /* TOPIC6_22 */


#ifdef TOPIC6_23
.in_com_6_23
        defb    in_com_6_23end - in_com_6_23
        APPLBYTE(TOPIC6_23CODE)
        APPLNAME(TOPIC6_23KEY)
        APPLNAME(TOPIC6_23)
#ifdef TOPIC6_23HELP1
        defb    (in_com_hlp6_23 - in_help) /256
        defb    (in_com_hlp6_23 - in_help) %256
#else
        defb    0               ;pointer to help - use \0
#endif  /* TOPIC6_23HELP1) */
#ifdef TOPIC6_23ATTR
        APPLBYTE(TOPIC6_23ATTR)
#else
        defb    0
#endif /* TOPIC6_23ATTR */
        defb    in_com_6_23end - in_com_6_23
.in_com_6_23end
#endif /* TOPIC6_23 */


#ifdef TOPIC6_24
.in_com_6_24
        defb    in_com_6_24end - in_com_6_24
        APPLBYTE(TOPIC6_24CODE)
        APPLNAME(TOPIC6_24KEY)
        APPLNAME(TOPIC6_24)
#ifdef TOPIC6_24HELP1
        defb    (in_com_hlp6_24 - in_help) /256
        defb    (in_com_hlp6_24 - in_help) %256
#else
        defb    0               ;pointer to help - use \0
#endif  /* TOPIC6_24HELP1) */
#ifdef TOPIC6_24ATTR
        APPLBYTE(TOPIC6_24ATTR)
#else
        defb    0
#endif /* TOPIC6_24ATTR */
        defb    in_com_6_24end - in_com_6_24
.in_com_6_24end
#endif /* TOPIC6_24 */

/*
 * If we have the first item of next topic, then we carry on!
 */

#ifdef TOPIC7_1
        defb    1               ;end marker of current topic
#endif
