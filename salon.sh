#!/bin/bash
PSQL="psql -X --username=freecodecamp --dbname=salon --tuples-only -c"
echo -e "\n~~~~ MY SALON ~~~~\n"

MAIN_MENU(){
 
 if [[ $1 ]]
 then 
 echo -e "\n$1"
 fi 
 # get query 
 SERVICES_RESPONSE=$($PSQL "SELECT * FROM services")

 #loop through query

 echo "$SERVICES_RESPONSE" | while read ID BAR SERVICE
 do
  echo "$ID) $SERVICE"
done
echo "4) Exit"
 # read user input
 read SERVICE_ID_SELECTED

 case $SERVICE_ID_SELECTED in 
  1) SERVICE $SERVICE_ID_SELECTED ;;
  2) SERVICE $SERVICE_ID_SELECTED ;;
  3) SERVICE $SERVICE_ID_SELECTED ;;
  4) EXIT ;;
  *) MAIN_MENU  "I could not find that service. What would you like today?" ;;
 esac


}

EXIT(){
  echo -e "\nThank you for stopping in.\n"

}

SERVICE(){
  SERVICE_ID_SELECTED=$1
#  prompt for user phone number
echo -e "\nWhat is your phone number?"
read CUSTOMER_PHONE

#QUERY PHONE NUMBER 
CUSTOMER_NAME=$($PSQL "SELECT name FROM customers where phone = '$CUSTOMER_PHONE' ")
# if does not exist 

if [[ -z $CUSTOMER_NAME ]]
then 
  echo -e "\nI don't have a record for that phone number, what's your name?"
  read CUSTOMER_NAME
  INSERT_CUSTOMER_RESULT=$($PSQL "INSERT INTO customers (name, phone) values('$CUSTOMER_NAME', '$CUSTOMER_PHONE')")
  echo $INSERT_CUSTOMER_RESULT
fi
  #prompt for time
echo -e "\nWhat time would you like your cut, $CUSTOMER_NAME?"
read SERVICE_TIME

CUSTOMER_ID=$($PSQL "select customer_id from customers where phone = '$CUSTOMER_PHONE'")
#CREATE APOINTMENT
INSERT_APPOINTMENT_RESPONSE=$($PSQL "INSERT INTO appointments (customer_id, service_id, time) values($CUSTOMER_ID,$SERVICE_ID_SELECTED,'$SERVICE_TIME')")

SERVICE_NAME=$($PSQL "SELECT name FROM services WHERE service_id = $SERVICE_ID_SELECTED")

echo -e "\nI have put you down for a $(echo $SERVICE_NAME | sed -r 's/^ *| *$//g') at $SERVICE_TIME, $(echo $CUSTOMER_NAME | sed -r 's/^ *| *$//g')."
}



MAIN_MENU "Welcome to My Salon, how can I help you?"