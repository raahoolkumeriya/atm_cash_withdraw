#!/bin/bash

#----------------------------------------------------------
#		Script for creating User 
#		Bank side application
#		Thu Nov 17 18:09:04 IST 2016
#---------------------------------------------------------

CARD_NO=`date +%d%m%s%S%n`
echo "Card Number : $CARD_NO" 
echo
echo -n "Enter PIN : "
read PIN
echo
echo -n "Enter Name : "
read name
echo
echo -n "Enter address "
read address
echo
echo

sqlplus -s $ORA_USER/$ORA_PASS<<EOF
INSERT INTO TRANSCATION_DETAILS values ($CARD_NO,0,500,0,500,SYSDATE);
commit;
exit;
EOF

sqlplus -s $ORA_USER/$ORA_PASS<<EOF
INSERT INTO USER_EXIST values ($CARD_NO,'$name',$PIN,'$address',SYSDATE);
commit;
exit;
EOF


echo
echo -n "\t\t\t\t\t New user created Successfully "
echo
echo
echo "Deposit 500 rupees to Open the Account in Unix BANK"
echo ""

 	
