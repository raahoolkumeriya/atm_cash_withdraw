#!/bin/bash

#------------------------------------------------------
#           Change PIN Script
#	Thu Nov 17 13:16:16 IST 2016
#-----------------------------------------------------
echo "$(date '+%D %T' | toilet -f term -F border --gay)"
#CARD_NO=1911147957643313
echo $CARD_NO

echo "Enter your existing PIN : "

echo "SELECT PIN FROM USER_EXIST WHERE CARD_NO=$CARD_NO;" > select.sql
PIN=`sh $SCRIPT_PATH/oracle_connect.sh select.sql`

echo PIN $PIN
read -s old_PIN
echo old_pin $old_PIN
echo
if [[ "$old_PIN" -eq "$PIN" ]]
then
	echo "Enter Your New PIN   : "
	read  -s new_PIN
	if [[ "$old_PIN" -ne "$new_PIN" ]]
	then
		echo "Confirm your New PIN : "
		read -s new_PIN_confirm
		if [[ "$new_PIN" == "$new_PIN_confirm" ]]
		then	
sqlplus -s $ORA_USER/$ORA_PASS << EOD
UPDATE USER_EXIST SET PIN=$new_PIN_confirm WHERE CARD_NO=$CARD_NO;
commit;
exit;
EOD
			
			echo "Your PIN has been SUccessfully Changed"
		else
			echo "Your new PIN and Confirm PIN does not Match"
		fi

	else
		echo "You can NOT use teh same PIN"
	fi
else
	echo "Please enter the correct PIN"
fi
