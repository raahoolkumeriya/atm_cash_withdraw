#!/bin/bash

#--------------------------------------------------------------------
#		FAST CASH : DISPACTH fix amount without enter
#			Wed Nov 16 22:13:40 IST 2016
#-------------------------------------------------------------------
clear
echo "$(date '+%D %T' | toilet -f term -F border --gay)"
echo
echo
echo $(tput setaf 4)
echo ""
echo -e "\t\t\t\t\t==============================================="
echo 
echo -e "\t\t\t\t\t2500\t\t\t\t\t5000"
echo 	
echo -e "\t\t\t\t\t7000\t\t\t\t\t10000"
echo	
echo -e "\t\t\t\t\t15000\t\t\t\t\t20000"
echo 
echo -e "\t\t\t\t\t==============================================="
echo 
echo $(tput sgr0)
echo -e -n "\t\t\t\t\tSelect above amount for dispactch : "
read withdraw_amount


echo "select AVAILABLE_BALANCE from ( select * from TRANSCATION_DETAILS order by DATE_TIME desc ) where ROWNUM = 1;" > select.sql 
OLD_AVAILABLE_BALANCE=`sh $SCRIPT_PATH/oracle_connect.sh select.sql`

echo
#echo $OLD_AVAILABLE_BALANCE
#echo old_available_balance  $old_available_balance
if [[ "$withdraw_amount" -lt "$OLD_AVAILABLE_BALANCE" ]]
then
#	echo $old_available_balance
#	echo $withdraw_amount	
	AVAILABLE_BALANCE=$((OLD_AVAILABLE_BALANCE - withdraw_amount))
#	echo $available_balance
	
sqlplus -s $ORA_USER/$ORA_PASS<<EOF
INSERT INTO TRANSCATION_DETAILS VALUES ( $CARD_NO,$OLD_AVAILABLE_BALANCE,0,$withdraw_amount,$AVAILABLE_BALANCE,SYSDATE );
commit;
exit;
EOF

	echo
	echo -e "\t\t\t\t\t$(tput setab 1) ₹ $withdraw_amount $(tput sgr0) is perparing for dispatch " 
	sleep 1
	echo 
	echo -e "\t\t\t\t\t\tAvailable Balance = $(tput setab 4) $AVAILABLE_BALANCE $(tput sgr0)"
	echo 
	tput bold
	tput setaf 4
	echo -e "\t\t\t\t\t\t $(tput setab 7) PLEASE COLLECT YOUR CASH $(tput sgr0) "
	tput sgr0
	sleep 1
	./thanks_quote.sh
    
else 
	tput setaf 1
	echo -e "\t\t\t\t\t\t Your account balance is low "
	echo -e "\t\t\t\t\t\t Your balance is $(tput setab 4) $OLD_AVAILABLE_BALANCE $(tput sgr0) "
	tput sgr0
	sleep 2
	./fast_cash.sh
fi		
