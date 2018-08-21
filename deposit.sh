#!/bin/bash

#---------------------------------------------------------------
#		deposit amount for users
#	      Thu Nov 17 09:54:35 IST 2016	
#--------------------------------------------------------------
#echo $CARD_NO
#grep $CARD_NO ./bank_database/$CARD_NO
#CARD_NO=2011147961428707
echo
echo
echo -n -e "\t\t\t\tPlease enter the Amount to be Deposit : "
read deposit_Amount
echo
echo
echo "select AVAILABLE_BALANCE from ( select * from TRANSCATION_DETAILS where CARD_NO=$CARD_NO order by DATE_TIME desc ) where ROWNUM = 1;" > select.sql
OLD_AVAILABLE_BALANCE=`sh $SCRIPT_PATH/oracle_connect.sh select.sql`

#--SELECT TO_CHAR(AVAILABLE_BALANCE) FROM TRANSCATION_DETAILS where card_no=$CARD_NO;

AVAILABLE_BALANCE=$((OLD_AVAILABLE_BALANCE + deposit_Amount ))

sqlplus -s $ORA_USER/$ORA_PASS<<EOF
INSERT INTO TRANSCATION_DETAILS VALUES ( $CARD_NO,$OLD_AVAILABLE_BALANCE,$deposit_Amount,0,$AVAILABLE_BALANCE,SYSDATE );
commit;
exit;
EOF

echo 
echo
