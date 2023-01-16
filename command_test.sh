#!/bin/bash

clear
Start_time=$(date +"%c")
echo "******My Command Line Test - Project*****"
echo "Please choose the correct option:"
help_func() {
        echo "1.Sign In"
        echo "2.Sign Up"
        echo "3.Exit"
        read press
        case $press in
        1)sign_in
                ;;
        2)sign_up
                ;;
        3)echo " Thank You!! for visiting "
	  echo "$username log-out at $Start_time." >> testfile_log.txt
		break
		;;
        esac
}

sign_up() {

        echo "******My Command Line Project******"
        echo "*****Sign Up Screen*****"
	read -p " Please choose your username " username
	if grep -q -w "$username"* user_id_info.txt
	then
		echo "Username Already Exist!!"
	else
		if test -z "$(echo -n "$username" |tr -d 'a-zA-Z0-9')"
		then
		       	read -s -p " Enter your password " pass
                        len="${#pass}"
			if [ $len -ge 7 ];then
				read -s -p " Re-enter your password " passw
				if [ $pass = $passw ];then
					echo " $pass,$username" >> user_id_info.txt
					echo " Sign up by $username at $Start_time" >> testfile_log.txt
					echo "*** Sign Up Sucessfully.*** "
				else
					echo " Password Not Matched"
				fi
			else
				echo "Password must contain 8 chracter!!"
			fi
		else
			echo "Invalid Username!!(Note:- Username contain alphabets and numbers only)" 
		fi
	fi

        echo "*****Return to main menu*****"
	help_func
}

sign_in() {
	echo "******My Command Line Project*****"
        echo "*****Sign In Screen*****"
        read -p "Enter Your Username:" username
        read -s -p  "Enter your Password:" password
	if grep -q -w "$password","$username"* user_id_info.txt
	then
		echo "***Username Matched***"
		echo " Login sucessful."
	     	echo "***My Command Line Test***"
                echo "1.Take a Test"
                echo "2.View Your Test"
                echo "3.Exit"
                read press
                case $press in 
                1) if [ -f /home/ec2-user/command_test/User_Answer/$username.Answer.csv ];then
			echo "***You Already Attempt The Test***"
			echo "*** Choose Furher Option ***"
			echo "1.Return to main menu"
			echo "2.View Your Test"
                       	echo "3.Exit"
                        read press
                        case $press in
				1)help_func
					;;
                               	2)view_test
                                       	;;
                               	3)echo " Thank You!! for visiting "
                               	  echo "$username log-out at $Start_time." >> testfile_log.txt
                                  break
			esac
	           else
			   take_test
		  fi
		             ;;
                2)if [ -f /home/ec2-user/command_test/User_Answer/$username.Answer.csv ];then
			view_test
		  else
			  echo " ***Please Take Your Test First***"
                          echo "*** Choose Further Option ***"
                          echo "1.Return to main menu"
                          echo "2.Take Your Test"
                          echo "3.Exit"
                          read press
                          case $press in
                                1)help_func
                                        ;;
                                2)take_test
                                        ;;
                                3)echo "***** Thank You!! for visiting ******"
                                  echo "$username log-out at $Start_time." >> testfile_log.txt
			  esac

		 fi
		
			
                        	;;
		3)echo " Thank You!! for visiting "
		  echo "$username log-out at $Start_time." >> testfile_log.txt
		  break
                        	;;
        	esac
	
	else
		echo "**Invalid User-Id**"
		help_func
	fi
	
}

take_test() {
	clear
	echo "Test started by $username at $Start_time." >> testfile_log.txt
	echo -e "Test Screen:\n"
	num=$(cat question.txt | wc -l)
	echo "" >> /home/ec2-user/command_test/User_Answer/$username.Answer.csv

    	for i in `seq 5 5 ${num}`
    	do
        	option=""
        	cat question.txt | head -${i} | tail -5
        	echo
        	for j in `seq 9 -1 0`
        	do
			echo -e "\rTime remaining: ${j}\tChoose your option: \c"
        		read -t 1 option
            		if [ -n "${option}" ]
            		then
                		break
            		else
                		option=""
			fi
		done
	
        	echo "${option}" >> /home/ec2-user/command_test/User_Answer/$username.Answer.csv
       		 
    	done
   	clear

    echo "Test submitted successfully by $username at $Start_time." >> testfile_log.txt
    echo -e "Test completed successfully!\n"
    result

}

result(){
	sed -i '/^[[:blank:]]*$/d' /home/ec2-user/command_test/User_Answer/$username.Answer.csv
	score=0
	user_answer=(`cat /home/ec2-user/command_test/User_Answer/$username.Answer.csv`)
	original_answer=(`cat Original_Answer.txt`)
	length=$((${#user_answer[@]} - 1))
	for i in `seq 0 ${length}`
	do
		if [ "${user_answer[i]}" = "${original_answer[i]}" ];
		then
			score=$((${score} + 1))
		fi
	done
	
	echo -e "Your Result out of 10 is: ${score}\n"
	echo "1.view your test"
       	echo "2.Return to main menu"
	echo "3.Exit"
	read press
	if [ $press == 1 ];then
		view_test
	elif [ $press == 2 ];then
                help_func
        else
	       	echo "Thank You!!, Visit Again"
		echo "$username log-out at $Start_time." >> testfile_log.txt
		break
       	fi
}

view_test() {
	echo -e "\nYour Test is as follow:\n"
    	num=$(cat question.txt | wc -l)
   	user_answer=(`cat /home/ec2-user/command_test/User_Answer/$username.Answer.csv`)
   	original_answer=(`cat Original_Answer.txt`)

    	for i in `seq 5 5 ${num}`
    	do
        	cat question.txt | head -${i} | tail -5
		echo
		Yellow='\e[0;93m'
		Cyan='\e[0;96m'
		NC='\033[0m'
		echo -e "${Yellow}The Answer given by you is - ${user_answer[$(((${i}/5)-1))]}${NC}"
        	echo -e "${Cyan}The correct answer is - ${original_answer[$(((${i}/5)-1))]}${NC}\n"
    	done
        echo " ********CHOOSE FURTHER OPTIONS****** "
        echo "1.Take a Test"
        echo "2.View Your Test"
        echo "3.Exit"
        read press
	if [ $press == 1 ];then
		if [ -f /home/ec2-user/command_test/User_Answer/$username.Answer.csv ];then
			echo "***You Already Attempt The Test***"
			echo "*** Choose Furher Option ***"
			echo "1.Return to main menu"
			echo "2.View Your Test"
			echo "3.Exit"
			read press
			case $press in
				1)help_func
				       	;;
                                2)view_test
                                        ;;
                                3)echo " Thank You!! for visiting "
				  echo "$username log-out at $Start_time." >> testfile_log.txt
                                       break
                                        ;;
                         esac
		else
			take_test
		fi
	elif [ $press == 2 ];then
		if [ -f /home/ec2-user/command_test/User_Answer/$username.Answer.csv ];then
			view_test
		else
			echo " ***Please Take Your Test First***"
			echo "*** Choose Further Option ***"
                        echo "1.Return to main menu"
                        echo "2.Take Your Test"
                        echo "3.Exit"
                        read press
                        case $press in
                                1)help_func
                                        ;;
                                2)take_test
                                        ;;
                                3)echo "***** Thank You!! for visiting ******"
				  echo "$username log-out at $Start_time." >> testfile_log.txt
                                       break
                                        ;;
                         esac

		fi
	else
		echo " Thank you for visiting!!"
		echo "$username log-out at $Start_time." >> testfile_log.txt
		break
	fi

}

help_func
