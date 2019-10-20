
#include <drivers/rs232.h>

extern port_info_s port_info;


/******************************************************************/

void irq_sci (struct port_info_t *pi_sp)
{
	int tmp;
	unsigned char rxc;
    unsigned char discard;


    if(pi_sp->output_remove == pi_sp->output_insert)
    {

         /* no more data */
/*       if(pi_sp->rts_mode == rs232_rts_off_when_done)*/
         /*turn rts off (P80)*/
/*       P8DR &= ~0X01;*/

         /*Turn tx interrupts off */
         //S_IMR=SCI_NOTXIRQ;
		
		
		{
           //  S_ISR &= ~Sm_txhem; /*Clear tx interrupt*/

             /*transfer byte to tx holding register */
          //   S_TXBR=pi_sp->output_buffer[pi_sp->output_remove++];
             pi_sp->output_remove &= RS232_BUFFERMASK;
		}
    }

    /*character received */
	{

    //    rxc = S_RXBR;/*get the char */
        discard=0;

		if (pi_sp->ctrlSen)
		{
		    if(rxc == CTRLS)
		    {
                /*disable transmitter */
			    pi_sp->ctrlSrx = 1;
      //  	    S_IMR=SCI_NOTXIRQ;/*disable tx ints */
		        discard=1;
		    }
		    else if(rxc == CTRLQ)
			{
                 /*enable the transmitter */
			     pi_sp->ctrlSrx = 0;
		//	     S_IMR=SCI_ENTXIRQ;/*enable tx ints */
			     discard=1;
			}
		}
        if (!discard) /*discard because of ctrlx - ctrls*/
		{
		    tmp = pi_sp->input_insert + 1 & RS232_BUFFERMASK;
            if(tmp != pi_sp->input_remove)
			{
                pi_sp->input_buffer[pi_sp->input_insert] = rxc;
                pi_sp->input_insert = tmp;
                //now_time=get_microsecs();
              //  if (now_time - pi_sp->last_char_rxd_time
              //               > pi_sp->msg_start_gap)
             //   {
              //      pi_sp->msg_start_index=tmp;
             //   }
             //   pi_sp->last_char_rxd_time = now_time;
			}
			/* else buffer full, throw away. */
		}
        //S_ISR &= ~Sm_rxdp; /*Clear rx interrupt*/
	}/*end if else rx interrupt*/
}

void RS232_isr( void )
{

}
