#!/bin/bash

#-------------------------------------------------------------------
#			Thu Nov 17 19:29:26 IST 2016
#  	script to transfer amount form one ATM card to Another	
#-------------------------------------------------------------------
echo "$(date '+%D %T' | toilet -f term -F border --gay)"
echo
echo
tput setaf 2
echo -e -n "\t\t\t\t\t Enter another ATM card number : "
read another_card_number

echo
echo -e -n "\t\t\t\t\t Please enter the Amount to be Transfer : "
read transfer_Amount
tput sgr0

echo "SELECT AVAILABLE_BALANCE from ( select * from TRANSCATION_DETAILS WHERE CARD_NO=$CARD_NO order by DATE_TIME desc ) where ROWNUM = 1;" > select.sql
old_available_balance=`sh $SCRIPT_PATH/oracle_connect.sh select.sql`

echo
available_balance=$((old_available_balance - transfer_Amount))

sqlplus -s $ORA_USER/$ORA_PASS<<EOF
INSERT INTO TRANSCATION_DETAILS VALUES ( $CARD_NO,$old_available_balance,0,$transfer_Amount,$available_balance,SYSDATE );
commit;
exit;
EOF

echo 
echo
tput setaf 3
echo -e "\t\t\t\t\t Amount Transfer in $(tput setab 7) $another_card_number $(tput sgr0)"
tput sgr0

echo "SELECT AVAILABLE_BALANCE from ( select * from TRANSCATION_DETAILS WHERE CARD_NO=$another_card_number order by DATE_TIME desc ) where ROWNUM = 1;" > select.sql
old_available_balance1=`sh $SCRIPT_PATH/oracle_connect.sh select.sql`

available_balance1=$((old_available_balance1 + transfer_Amount))

echo
sqlplus -s $ORA_USER/$ORA_PASS<<EOF
INSERT INTO TRANSCATION_DETAILS VALUES ( $another_card_number,$old_available_balance1,0,$transfer_Amount,$available_balance1,SYSDATE );
commit;
exit;
EOF
echo

echo
echo -e "\t\t\t\t\t\tAvailable Balance = $(tput setab 4) $available_balance1 $(tput sgr0)"
echo 
echo
