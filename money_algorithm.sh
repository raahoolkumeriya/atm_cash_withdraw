#!/bin/bash

#-----------------------------------------------------------------------------
#			for 100,500,1000,2000 Rupee Notes
#			  Wed Nov 16 19:59:23 IST 2016	
#-----------------------------------------------------------------------------
echo
echo 
echo -e -n "\t\t\t\t\tEnter the Amount :"
read AMOUNT
withdraw_amount=$AMOUNT
if [[ "$AMOUNT" -le 10100 ]]
then

	if [[ "$AMOUNT" > 2000 ]]
	then 
		no_of_2000_note=$(( $AMOUNT / 2000 ))
		remaing_cash=$(($no_of_2000_note * 2000))
		AMOUNT=$(($AMOUNT - $remaing_cash)) 
		#echo no of 2000 notes receive $no_of_2000_note
	fi


	if [[ "$AMOUNT" -le 2000 ]]
	then
		no_of_1000_note=$(( $AMOUNT / 1000 ))
		remaing_cash=$(($no_of_1000_note * 1000))
		AMOUNT=$(($AMOUNT - $remaing_cash)) 
		#echo no of 1000 notes receive $no_of_1000_note
	fi
	if [[ "$AMOUNT" -le 1000 ]]
	then
		if [[ "$AMOUNT" -ge 500 ]]
		then
			amount1=$(($AMOUNT - 500))
			no_of_100_note=$(( $amount1 / 100 ))
			remaing_cash=$(($no_of_100_note * 100))
			AMOUNT=$(($AMOUNT - $remaing_cash)) 
			no_of_500_note=$(( $AMOUNT / 500 ))
		fi
			#echo no of 500 notes receive $no_of_500_note
	fi


	if [[ "$AMOUNT"  < 500 ]]
	then
		no_of_100_note=$(( $AMOUNT / 100 ))
	fi

	if (( $AMOUNT % 100 == 0 ))
	then
		echo
		echo -e "\t\tYou collected cash -"
		echo -e "\t\t\t\t\t=============================================="
		echo -e "\t\t\t\t\t\tNo. of Notes\tParticular"
		echo -e "\t\t\t\t\t=============================================="
		echo -e "\t\t\t\t\t\t$no_of_2000_note\t\t2000 Note"
		echo -e "\t\t\t\t\t=============================================="
		echo -e "\t\t\t\t\t\t$no_of_1000_note\t\t1000 Note"
		echo -e "\t\t\t\t\t=============================================="
		echo -e "\t\t\t\t\t\t$no_of_500_note\t\t500 Note"
		echo -e "\t\t\t\t\t=============================================="
		echo -e "\t\t\t\t\t\t$no_of_100_note\t\t100 Note"
		echo -e "\t\t\t\t\t=============================================="
		echo 


echo "select AVAILABLE_BALANCE from ( select * from TRANSCATION_DETAILS where CARD_NO=$CARD_NO order by DATE_TIME desc ) where ROWNUM = 1;" > select.sql
OLD_AVAILABLE_BALANCE=`sh $SCRIPT_PATH/oracle_connect.sh select.sql`
echo

	if [[ "$withdraw_amount" -lt "$OLD_AVAILABLE_BALANCE" ]]
	then
        	available_balance=$((OLD_AVAILABLE_BALANCE - withdraw_amount))
        	
		`sqlplus -s $ORA_USER/$ORA_PASS<<EOF
		INSERT INTO TRANSCATION_DETAILS VALUES ( $CARD_NO,$OLD_AVAILABLE_BALANCE,0,$withdraw_amount,$available_balance,SYSDATE );
                commit;
		exit;
		EOF`		
		echo

		echo -e "\t\t\t\t\t\t$(tput setab 1) ₹ $withdraw_amount $(tput sgr0) is perparing for dispatch "
         	 sleep 1
      		 echo
		 echo -e "\t\t\t\t\t\tAvailable Balance = $(tput setab 4) $available_balance $(tput sgr0)"
       		# echo " Avaialable Balance = " $available_balance
      		 echo
		 tput setaf 4 	
	  	 echo -e "\t\t\t\t\t\t $(tput setab 7) PLEASE COLLECT YOUR CASH $(tput sgr0) "
        	 sleep 1
   	    	 ./thanks_quote.sh
	fi


	else
		echo -e "\t\t\t\t\tPlease enter the correct Amount"
	fi

else 
clear
tput setaf 1
echo -e "\t\t\t\tYou CAN NOT make such BIG transaction at a single time"
echo -e "\t\t\t\t\t Please try amount less than 10,000 "
tput sgr0
	./money_algorithm.sh
fi
