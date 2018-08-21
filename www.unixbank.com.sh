#!/bin/bash

SCRIPT_PATH=$PWD

clear
#--------------------------------------------------------------
#		Thu Nov 17 00:53:39 IST 2016
#--------------------------------------------------------------
echo
#set +a
export $CARD_NO
#set -a
echo "$(date '+%D %T' | toilet -f term -F border --gay)"
echo $(tput setaf 4) "
	000  0000 0   0 0  0 	0000 0000	0   0 0   0 00000 0   0 
	0  0 0  0 00  0 0 0  	0  0 0		0   0 00  0   0    0 0
	0000 0000 0 0 0 00  	0  0 0000	0   0 0 0 0   0     0
	0  0 0  0 0  00 0 0  	0  0 0		0   0 0  00   0    0 0
	000  0  0 0   0 0  0 	0000 0		00000 0   0 00000 0   0"
echo $(tput setaf 1) '                                                                           
                                ``...--:://++ooooo/:.`                     
                                        ```...----/+shhs/-`                
                     ``                    ````.-::///++oyds:`             
                     `.-------.``                 `....:+oosyds-           
 `                        ```.-://+++o+/:-.`     `s.`    `-/ssshh:`        
 `.`                               `..-/oydmy+-` `h-      ``.:ssohh:       
  `.-.           `                  `.---:+mNy+:..-+o+++oso++++shsohs`     
     .::.        `.      ``..--::////////::///+///:--..-::////++oo+:yh-    
       .:/:.      -.    ````````````.--/+syhddddhhhdddmdy+:-....-/oyhNm:   
         `-/+/-`   /:                     `.-+ydNMMMMd+.            ./hm/  
            `-/oo/-.+s.          `.`        `.:+ymMNo`                `:h: 
                .:+syhdo.          .-.`     ````-mN/                    `+`
                 -::ss-:++-`         `-:-.`````.+h:                       `
                  .+o:.` `/y:.`        `-://+ooo/--::/::.`                 
                    `-++.` -.:/:.`   ``` `.--::+shs+:-.-:/+:`              
                       `...`   `---.```--`` `.-::///:-.`  `/s:             
                              ```   `````-//:-.......:/+-`  `o:            
                               `...``     `-+o+++hNs::--:-.`.o/            
                                `.-:-:::::://o++so:`      `-:sy            
                                   .-:/++++ooo+-             `:            
                                         ```                               
' $(tput sgr0) 

#set -a
export CARD_NO
#set +a
echo
echo -n -e "\tPlease Enter your ATM CARD no  : "
read CARD_NO
echo $(tput setaf 3)


#    FETCHIMG DATA FROM TABLE
echo "SELECT TO_CHAR(card_no) FROM user_exist where card_no=$CARD_NO;" > select.sql
correct_card_no=`sh $SCRIPT_PATH/oracle_connect.sh select.sql`


echo "SELECT TO_CHAR(pin) FROM user_exist where card_no=$CARD_NO;" > select.sql
correct_pin=`sh $SCRIPT_PATH/oracle_connect.sh select.sql`


echo "SELECT TO_CHAR(user_name) FROM user_exist where card_no=$CARD_NO;" > select.sql
user_name=`sh $SCRIPT_PATH/oracle_connect.sh select.sql`


echo $(tput setaf 3)
echo -e "\t\t\t\tWelcome $user_name " 

echo $(tput sgr0)
if [[ "$CARD_NO" == "$correct_card_no" ]] 
then 
	export CARD_NO
	echo -n -e "\t\tPlease enter your PIN  : "
	read -s PIN 
	echo $PIN
#	correct_pin=`cat user_exist | grep $CARD_NO |awk -F"|" '{print $2}'`
#	correct_pin=`fetch_pin`

	echo $correct_pin
	if [[ "$PIN"  == "$correct_pin" ]]
	then
	./welcome_sceen.sh
        else
	echo $(tput setaf 1)
	echo -e "\t\t\t\tPlease enter the correct PIN"
	echo
	echo
	fi
else
	echo $(tput setaf 1)
	echo -e "\t\t\t\tPlease enter the correct CARD number"
	echo
	echo
fi
                                                         
	export CARD_NO
	

