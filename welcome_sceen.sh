#!/bin/bash

#------------------------------------------------------------------
#		Welcome screen
#	Wed Nov 16 22:39:09 IST 2016
#-----------------------------------------------------------------

SCRIPT_PATH=$PWD

clear
echo "$(date '+%D %T' | toilet -f term -F border --gay)"
#echo $CARD_NO
set -a
export CARD_NO=$CARD_NO
set +a
echo
echo -e "\t\t\t\t\t$(tput setab 4)     WELCOME TO BANK OF UNIX    $(tput sgr0)"
echo 
echo
echo -e "\t\t\t\t\t=================================="
echo -e "\t\t\t\t\t\t$(tput setaf 3)SELECT Transaction $(tput sgr0)"
echo -e "\t\t\t\t\t=================================="
echo 
echo $(tput setaf 5)
echo ' '   
	
echo -e "\t\t\t\t1 DEPOSIT\t\t\t\t2 FAST CASH"
echo
echo -e "\t\t\t\t3 TRANSFER\t\t\t\t4 CASH WITHDRAWAL"
echo
echo -e "\t\t\t\t5 PIN CHANGE\t\t\t\t6 BALANCE ENQUIRY"
echo
echo -e "\t\t\t\t7 OTHERS\t\t\t\t8 MINI STATEMENT"
echo 
echo 
echo 
echo $(tput sgr0)
echo
echo
tput cup 22 50                                                
echo -n "Option : "
read options

case $options in 
	1|deposit|DEPOSIT|Deposit)
		. ./deposit.sh		
	echo
	;;

	2|FAST|fast|fastcash|FASTCASH|Fashcash)
	echo
		. ./fast_cash.sh
	echo
	;;	

	3|transfer|TRANSFER|Transfer)
	echo
		. ./transfer_amount.sh
	echo
	;;
		
	4|cash|CASH|CASHWITHDRAWAL|CashWithdrawal)
	echo
		. ./money_algorithm.sh		
	echo
	;;

	5|pin|PIN|PINCHANGE)
		. ./pin_change.sh	
	;;

	6|BALANCE|balance|balancenquiry)
	
	echo "SELECT AVAILABLE_BALANCE from ( select * from TRANSCATION_DETAILS where CARD_NO=$CARD_NO order by DATE_TIME desc ) where ROWNUM = 1;" > select.sql
	AVAILABLE_BALANCE=`sh $SCRIPT_PATH/oracle_connect.sh select.sql`
	echo
	 echo -n "AVAILABLE_BALANCE = " $(tput setab 4 ) $AVAILABLE_BALANCE  $(tput sgr0)
		echo
	;;
	
	7|other|OTHERS)
		
	;;
		
	8|MINI|mini|MiniStatement)
	echo
	echo
	sqlplus -s $ORA_USER/$ORA_PASS<<EOF > balance.txt
set heading off
set feed off
set linesize 2500 trimspool on
--set colsep ,
set head off
set pages 0
--set numf 
set serveroutput on
set feedback off
SELECT to_char(CARD_NO),OLD_AVAILABLE_BALANCE,DEPOSIT,WITHDRAW,AVAILABLE_BALANCE,DATE_TIME FROM TRANSCATION_DETAILS  WHERE CARD_NO=$CARD_NO order by DATE_TIME desc;
exit;
EOF

#	awk -F "," '{print $1 $2 $3 $4 $5 $6}' balance.txt

	awk -F" " '
BEGIN { 
print "----------------------------------------------------------------------------------------------------------------"
printf "%-20s %-15s %-15s %-15s %-15s %-20s\n" , "CARD_NO","Old_Available","Deposite","Withdraw","Available","DateTime"
print "-----------------------------------------------------------------------------------------------------------------"
}
NR==1,NR==10 { printf "%-20s %-15s %-15d %-15d %-15s %-20s\n",$1,$2,$3,$4,$5,$6}' balance.txt


	echo
	echo 
	echo

	;;
	
	*)
		echo "Please enter the correct option"

esac
	
