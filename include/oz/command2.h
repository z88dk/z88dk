/*
 *      Header for command entries for Topic 2
 *
 *      Do not include yourself - included by application.h
 *
 *      7/4/99 djm
 */


#ifdef TOPIC2_1
.in_com_2_1
        defb    in_com_2_1end - in_com_2_1
        APPLBYTE(TOPIC2_1CODE)
        APPLNAME(TOPIC2_1KEY)
        APPLTEXT(TOPIC2_1)
#ifdef TOPIC2_1HELP1
        defb    (in_com_hlp2_1 - in_help) /256
        defb    (in_com_hlp2_1 - in_help) %256
#else
        defb    0,0               ;pointer to help - use \0
#endif  /* TOPIC2_1HELP1) */
#ifdef TOPIC2_1ATTR
        APPLBYTE(TOPIC2_1ATTR)
#else
        defb    0
#endif /* TOPIC2_1ATTR */
        defb    in_com_2_1end - in_com_2_1
.in_com_2_1end
#endif /* TOPIC2_1 */


#ifdef TOPIC2_2
.in_com_2_2
        defb    in_com_2_2end - in_com_2_2
        APPLBYTE(TOPIC2_2CODE)
        APPLNAME(TOPIC2_2KEY)
        APPLTEXT(TOPIC2_2)
#ifdef TOPIC2_2HELP1
        defb    (in_com_hlp2_2 - in_help) /256
        defb    (in_com_hlp2_2 - in_help) %256
#else
        defb    0,0               ;pointer to help - use \0
#endif  /* TOPIC2_2HELP1) */
#ifdef TOPIC2_2ATTR
        APPLBYTE(TOPIC2_2ATTR)
#else
        defb    0
#endif /* TOPIC2_2ATTR */
        defb    in_com_2_2end - in_com_2_2
.in_com_2_2end
#endif /* TOPIC2_2 */


#ifdef TOPIC2_3
.in_com_2_3
        defb    in_com_2_3end - in_com_2_3
        APPLBYTE(TOPIC2_3CODE)
        APPLNAME(TOPIC2_3KEY)
        APPLNAME(TOPIC2_3)
#ifdef TOPIC2_3HELP1
        defb    (in_com_hlp2_3 - in_help) /256
        defb    (in_com_hlp2_3 - in_help) %256
#else
        defb    0               ;pointer to help - use \0
#endif  /* TOPIC2_3HELP1) */
#ifdef TOPIC2_3ATTR
        APPLBYTE(TOPIC2_3ATTR)
#else
        defb    0
#endif /* TOPIC2_3ATTR */
        defb    in_com_2_3end - in_com_2_3
.in_com_2_3end
#endif /* TOPIC2_3 */


#ifdef TOPIC2_4
.in_com_2_4
        defb    in_com_2_4end - in_com_2_4
        APPLBYTE(TOPIC2_4CODE)
        APPLNAME(TOPIC2_4KEY)
        APPLNAME(TOPIC2_4)
#ifdef TOPIC2_4HELP1
        defb    (in_com_hlp2_4 - in_help) /256
        defb    (in_com_hlp2_4 - in_help) %256
#else
        defb    0               ;pointer to help - use \0
#endif  /* TOPIC2_4HELP1) */
#ifdef TOPIC2_4ATTR
        APPLBYTE(TOPIC2_4ATTR)
#else
        defb    0
#endif /* TOPIC2_4ATTR */
        defb    in_com_2_4end - in_com_2_4
.in_com_2_4end
#endif /* TOPIC2_4 */


#ifdef TOPIC2_5
.in_com_2_5
        defb    in_com_2_5end - in_com_2_5
        APPLBYTE(TOPIC2_5CODE)
        APPLNAME(TOPIC2_5KEY)
        APPLNAME(TOPIC2_5)
#ifdef TOPIC2_5HELP1
        defb    (in_com_hlp2_5 - in_help) /256
        defb    (in_com_hlp2_5 - in_help) %256
#else
        defb    0               ;pointer to help - use \0
#endif  /* TOPIC2_5HELP1) */
#ifdef TOPIC2_5ATTR
        APPLBYTE(TOPIC2_5ATTR)
#else
        defb    0
#endif /* TOPIC2_5ATTR */
        defb    in_com_2_5end - in_com_2_5
.in_com_2_5end
#endif /* TOPIC2_5 */


#ifdef TOPIC2_6
.in_com_2_6
        defb    in_com_2_6end - in_com_2_6
        APPLBYTE(TOPIC2_6CODE)
        APPLNAME(TOPIC2_6KEY)
        APPLNAME(TOPIC2_6)
#ifdef TOPIC2_6HELP1
        defb    (in_com_hlp2_6 - in_help) /256
        defb    (in_com_hlp2_6 - in_help) %256
#else
        defb    0               ;pointer to help - use \0
#endif  /* TOPIC2_6HELP1) */
#ifdef TOPIC2_6ATTR
        APPLBYTE(TOPIC2_6ATTR)
#else
        defb    0
#endif /* TOPIC2_6ATTR */
        defb    in_com_2_6end - in_com_2_6
.in_com_2_6end
#endif /* TOPIC2_6 */


#ifdef TOPIC2_7
.in_com_2_7
        defb    in_com_2_7end - in_com_2_7
        APPLBYTE(TOPIC2_7CODE)
        APPLNAME(TOPIC2_7KEY)
        APPLNAME(TOPIC2_7)
#ifdef TOPIC2_7HELP1
        defb    (in_com_hlp2_7 - in_help) /256
        defb    (in_com_hlp2_7 - in_help) %256
#else
        defb    0               ;pointer to help - use \0
#endif  /* TOPIC2_7HELP1) */
#ifdef TOPIC2_7ATTR
        APPLBYTE(TOPIC2_7ATTR)
#else
        defb    0
#endif /* TOPIC2_7ATTR */
        defb    in_com_2_7end - in_com_2_7
.in_com_2_7end
#endif /* TOPIC2_7 */


#ifdef TOPIC2_8
.in_com_2_8
        defb    in_com_2_8end - in_com_2_8
        APPLBYTE(TOPIC2_8CODE)
        APPLNAME(TOPIC2_8KEY)
        APPLNAME(TOPIC2_8)
#ifdef TOPIC2_8HELP1
        defb    (in_com_hlp2_8 - in_help) /256
        defb    (in_com_hlp2_8 - in_help) %256
#else
        defb    0               ;pointer to help - use \0
#endif  /* TOPIC2_8HELP1) */
#ifdef TOPIC2_8ATTR
        APPLBYTE(TOPIC2_8ATTR)
#else
        defb    0
#endif /* TOPIC2_8ATTR */
        defb    in_com_2_8end - in_com_2_8
.in_com_2_8end
#endif /* TOPIC2_8 */


#ifdef TOPIC2_9
.in_com_2_9
        defb    in_com_2_9end - in_com_2_9
        APPLBYTE(TOPIC2_9CODE)
        APPLNAME(TOPIC2_9KEY)
        APPLNAME(TOPIC2_9)
#ifdef TOPIC2_9HELP1
        defb    (in_com_hlp2_9 - in_help) /256
        defb    (in_com_hlp2_9 - in_help) %256
#else
        defb    0               ;pointer to help - use \0
#endif  /* TOPIC2_9HELP1) */
#ifdef TOPIC2_9ATTR
        APPLBYTE(TOPIC2_9ATTR)
#else
        defb    0
#endif /* TOPIC2_9ATTR */
        defb    in_com_2_9end - in_com_2_9
.in_com_2_9end
#endif /* TOPIC2_9 */


#ifdef TOPIC2_10
.in_com_2_10
        defb    in_com_2_10end - in_com_2_10
        APPLBYTE(TOPIC2_10CODE)
        APPLNAME(TOPIC2_10KEY)
        APPLNAME(TOPIC2_10)
#ifdef TOPIC2_10HELP1
        defb    (in_com_hlp2_10 - in_help) /256
        defb    (in_com_hlp2_10 - in_help) %256
#else
        defb    0               ;pointer to help - use \0
#endif  /* TOPIC2_10HELP1) */
#ifdef TOPIC2_10ATTR
        APPLBYTE(TOPIC2_10ATTR)
#else
        defb    0
#endif /* TOPIC2_10ATTR */
        defb    in_com_2_10end - in_com_2_10
.in_com_2_10end
#endif /* TOPIC2_10 */


#ifdef TOPIC2_11
.in_com_2_11
        defb    in_com_2_11end - in_com_2_11
        APPLBYTE(TOPIC2_11CODE)
        APPLNAME(TOPIC2_11KEY)
        APPLNAME(TOPIC2_11)
#ifdef TOPIC2_11HELP1
        defb    (in_com_hlp2_11 - in_help) /256
        defb    (in_com_hlp2_11 - in_help) %256
#else
        defb    0               ;pointer to help - use \0
#endif  /* TOPIC2_11HELP1) */
#ifdef TOPIC2_11ATTR
        APPLBYTE(TOPIC2_11ATTR)
#else
        defb    0
#endif /* TOPIC2_11ATTR */
        defb    in_com_2_11end - in_com_2_11
.in_com_2_11end
#endif /* TOPIC2_11 */


#ifdef TOPIC2_12
.in_com_2_12
        defb    in_com_2_12end - in_com_2_12
        APPLBYTE(TOPIC2_12CODE)
        APPLNAME(TOPIC2_12KEY)
        APPLNAME(TOPIC2_12)
#ifdef TOPIC2_12HELP1
        defb    (in_com_hlp2_12 - in_help) /256
        defb    (in_com_hlp2_12 - in_help) %256
#else
        defb    0               ;pointer to help - use \0
#endif  /* TOPIC2_12HELP1) */
#ifdef TOPIC2_12ATTR
        APPLBYTE(TOPIC2_12ATTR)
#else
        defb    0
#endif /* TOPIC2_12ATTR */
        defb    in_com_2_12end - in_com_2_12
.in_com_2_12end
#endif /* TOPIC2_12 */


#ifdef TOPIC2_13
.in_com_2_13
        defb    in_com_2_13end - in_com_2_13
        APPLBYTE(TOPIC2_13CODE)
        APPLNAME(TOPIC2_13KEY)
        APPLNAME(TOPIC2_13)
#ifdef TOPIC2_13HELP1
        defb    (in_com_hlp2_13 - in_help) /256
        defb    (in_com_hlp2_13 - in_help) %256
#else
        defb    0               ;pointer to help - use \0
#endif  /* TOPIC2_13HELP1) */
#ifdef TOPIC2_13ATTR
        APPLBYTE(TOPIC2_13ATTR)
#else
        defb    0
#endif /* TOPIC2_13ATTR */
        defb    in_com_2_13end - in_com_2_13
.in_com_2_13end
#endif /* TOPIC2_13 */


#ifdef TOPIC2_14
.in_com_2_14
        defb    in_com_2_14end - in_com_2_14
        APPLBYTE(TOPIC2_14CODE)
        APPLNAME(TOPIC2_14KEY)
        APPLNAME(TOPIC2_14)
#ifdef TOPIC2_14HELP1
        defb    (in_com_hlp2_14 - in_help) /256
        defb    (in_com_hlp2_14 - in_help) %256
#else
        defb    0               ;pointer to help - use \0
#endif  /* TOPIC2_14HELP1) */
#ifdef TOPIC2_14ATTR
        APPLBYTE(TOPIC2_14ATTR)
#else
        defb    0
#endif /* TOPIC2_14ATTR */
        defb    in_com_2_14end - in_com_2_14
.in_com_2_14end
#endif /* TOPIC2_14 */


#ifdef TOPIC2_15
.in_com_2_15
        defb    in_com_2_15end - in_com_2_15
        APPLBYTE(TOPIC2_15CODE)
        APPLNAME(TOPIC2_15KEY)
        APPLNAME(TOPIC2_15)
#ifdef TOPIC2_15HELP1
        defb    (in_com_hlp2_15 - in_help) /256
        defb    (in_com_hlp2_15 - in_help) %256
#else
        defb    0               ;pointer to help - use \0
#endif  /* TOPIC2_15HELP1) */
#ifdef TOPIC2_15ATTR
        APPLBYTE(TOPIC2_15ATTR)
#else
        defb    0
#endif /* TOPIC2_15ATTR */
        defb    in_com_2_15end - in_com_2_15
.in_com_2_15end
#endif /* TOPIC2_15 */


#ifdef TOPIC2_16
.in_com_2_16
        defb    in_com_2_16end - in_com_2_16
        APPLBYTE(TOPIC2_16CODE)
        APPLNAME(TOPIC2_16KEY)
        APPLNAME(TOPIC2_16)
#ifdef TOPIC2_16HELP1
        defb    (in_com_hlp2_16 - in_help) /256
        defb    (in_com_hlp2_16 - in_help) %256
#else
        defb    0               ;pointer to help - use \0
#endif  /* TOPIC2_16HELP1) */
#ifdef TOPIC2_16ATTR
        APPLBYTE(TOPIC2_16ATTR)
#else
        defb    0
#endif /* TOPIC2_16ATTR */
        defb    in_com_2_16end - in_com_2_16
.in_com_2_16end
#endif /* TOPIC2_16 */


#ifdef TOPIC2_17
.in_com_2_17
        defb    in_com_2_17end - in_com_2_17
        APPLBYTE(TOPIC2_17CODE)
        APPLNAME(TOPIC2_17KEY)
        APPLNAME(TOPIC2_17)
#ifdef TOPIC2_17HELP1
        defb    (in_com_hlp2_17 - in_help) /256
        defb    (in_com_hlp2_17 - in_help) %256
#else
        defb    0               ;pointer to help - use \0
#endif  /* TOPIC2_17HELP1) */
#ifdef TOPIC2_17ATTR
        APPLBYTE(TOPIC2_17ATTR)
#else
        defb    0
#endif /* TOPIC2_17ATTR */
        defb    in_com_2_17end - in_com_2_17
.in_com_2_17end
#endif /* TOPIC2_17 */


#ifdef TOPIC2_18
.in_com_2_18
        defb    in_com_2_18end - in_com_2_18
        APPLBYTE(TOPIC2_18CODE)
        APPLNAME(TOPIC2_18KEY)
        APPLNAME(TOPIC2_18)
#ifdef TOPIC2_18HELP1
        defb    (in_com_hlp2_18 - in_help) /256
        defb    (in_com_hlp2_18 - in_help) %256
#else
        defb    0               ;pointer to help - use \0
#endif  /* TOPIC2_18HELP1) */
#ifdef TOPIC2_18ATTR
        APPLBYTE(TOPIC2_18ATTR)
#else
        defb    0
#endif /* TOPIC2_18ATTR */
        defb    in_com_2_18end - in_com_2_18
.in_com_2_18end
#endif /* TOPIC2_18 */


#ifdef TOPIC2_19
.in_com_2_19
        defb    in_com_2_19end - in_com_2_19
        APPLBYTE(TOPIC2_19CODE)
        APPLNAME(TOPIC2_19KEY)
        APPLNAME(TOPIC2_19)
#ifdef TOPIC2_19HELP1
        defb    (in_com_hlp2_19 - in_help) /256
        defb    (in_com_hlp2_19 - in_help) %256
#else
        defb    0               ;pointer to help - use \0
#endif  /* TOPIC2_19HELP1) */
#ifdef TOPIC2_19ATTR
        APPLBYTE(TOPIC2_19ATTR)
#else
        defb    0
#endif /* TOPIC2_19ATTR */
        defb    in_com_2_19end - in_com_2_19
.in_com_2_19end
#endif /* TOPIC2_19 */


#ifdef TOPIC2_20
.in_com_2_20
        defb    in_com_2_20end - in_com_2_20
        APPLBYTE(TOPIC2_20CODE)
        APPLNAME(TOPIC2_20KEY)
        APPLNAME(TOPIC2_20)
#ifdef TOPIC2_20HELP1
        defb    (in_com_hlp2_20 - in_help) /256
        defb    (in_com_hlp2_20 - in_help) %256
#else
        defb    0               ;pointer to help - use \0
#endif  /* TOPIC2_20HELP1) */
#ifdef TOPIC2_20ATTR
        APPLBYTE(TOPIC2_20ATTR)
#else
        defb    0
#endif /* TOPIC2_20ATTR */
        defb    in_com_2_20end - in_com_2_20
.in_com_2_20end
#endif /* TOPIC2_20 */


#ifdef TOPIC2_21
.in_com_2_21
        defb    in_com_2_21end - in_com_2_21
        APPLBYTE(TOPIC2_21CODE)
        APPLNAME(TOPIC2_21KEY)
        APPLNAME(TOPIC2_21)
#ifdef TOPIC2_21HELP1
        defb    (in_com_hlp2_21 - in_help) /256
        defb    (in_com_hlp2_21 - in_help) %256
#else
        defb    0               ;pointer to help - use \0
#endif  /* TOPIC2_21HELP1) */
#ifdef TOPIC2_21ATTR
        APPLBYTE(TOPIC2_21ATTR)
#else
        defb    0
#endif /* TOPIC2_21ATTR */
        defb    in_com_2_21end - in_com_2_21
.in_com_2_21end
#endif /* TOPIC2_21 */


#ifdef TOPIC2_22
.in_com_2_22
        defb    in_com_2_22end - in_com_2_22
        APPLBYTE(TOPIC2_22CODE)
        APPLNAME(TOPIC2_22KEY)
        APPLNAME(TOPIC2_22)
#ifdef TOPIC2_22HELP1
        defb    (in_com_hlp2_22 - in_help) /256
        defb    (in_com_hlp2_22 - in_help) %256
#else
        defb    0               ;pointer to help - use \0
#endif  /* TOPIC2_22HELP1) */
#ifdef TOPIC2_22ATTR
        APPLBYTE(TOPIC2_22ATTR)
#else
        defb    0
#endif /* TOPIC2_22ATTR */
        defb    in_com_2_22end - in_com_2_22
.in_com_2_22end
#endif /* TOPIC2_22 */


#ifdef TOPIC2_23
.in_com_2_23
        defb    in_com_2_23end - in_com_2_23
        APPLBYTE(TOPIC2_23CODE)
        APPLNAME(TOPIC2_23KEY)
        APPLNAME(TOPIC2_23)
#ifdef TOPIC2_23HELP1
        defb    (in_com_hlp2_23 - in_help) /256
        defb    (in_com_hlp2_23 - in_help) %256
#else
        defb    0               ;pointer to help - use \0
#endif  /* TOPIC2_23HELP1) */
#ifdef TOPIC2_23ATTR
        APPLBYTE(TOPIC2_23ATTR)
#else
        defb    0
#endif /* TOPIC2_23ATTR */
        defb    in_com_2_23end - in_com_2_23
.in_com_2_23end
#endif /* TOPIC2_23 */


#ifdef TOPIC2_24
.in_com_2_24
        defb    in_com_2_24end - in_com_2_24
        APPLBYTE(TOPIC2_24CODE)
        APPLNAME(TOPIC2_24KEY)
        APPLNAME(TOPIC2_24)
#ifdef TOPIC2_24HELP1
        defb    (in_com_hlp2_24 - in_help) /256
        defb    (in_com_hlp2_24 - in_help) %256
#else
        defb    0               ;pointer to help - use \0
#endif  /* TOPIC2_24HELP1) */
#ifdef TOPIC2_24ATTR
        APPLBYTE(TOPIC2_24ATTR)
#else
        defb    0
#endif /* TOPIC2_24ATTR */
        defb    in_com_2_24end - in_com_2_24
.in_com_2_24end
#endif /* TOPIC2_24 */

/*
 * If we have the first item of next topic, then we carry on!
 */

#ifdef TOPIC3_1
        defb    1               ;end marker of current topic
#endif
