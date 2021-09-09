#!/bin/bash


echo ""
echo "========== ANALYSIS START!! =========="
echo ""
echo ""


##### train data level
question=1
while [[ $question -gt 0 ]]; do

	echo -n "training data level? [i]: individual-level / [c]: condition-level / [r]: run-level / [t]: trial-level "

	tty_state=$(stty -g)
	stty raw
	char=$(dd bs=1 count=1 2> /dev/null)
	stty "$tty_state"

	echo

	case "$char" in
		[iI])
			train_data_level="individual_level"      
			question=$[ $question - 1 ]
		;;
		[cC])
			train_data_level="condition_level"
      			question=$[ $question - 1 ]
		;;
		[rR])
			train_data_level="run_level"
      			question=$[ $question - 1 ]
		;;
		[tT])
			train_data_level="trial_level"
			question=$[ $question - 1 ]
		;;	
    *)
      exit 1
    ;;
	esac
done

echo "Your choice is $train_data_level"
echo ""


##### test data level
question=1
while [[ $question -gt 0 ]]; do

	echo -n "independent test data level? [i]: individual-level / [c]: condition-level / [r]: run-level / [t]: trial-level "

	tty_state=$(stty -g)
	stty raw
	char=$(dd bs=1 count=1 2> /dev/null)
	stty "$tty_state"

	echo

	case "$char" in
		[iI])
			test_data_level="individual_level"      
			question=$[ $question - 1 ]
		;;
		[cC])
			test_data_level="condition_level"
      			question=$[ $question - 1 ]
		;;
		[rR])
			test_data_level="run_level"
      			question=$[ $question - 1 ]
		;;
		[tT])
			test_data_level="trial_level"
			question=$[ $question - 1 ]
		;;	
    *)
      exit 1
    ;;
	esac
done

echo "Your choice is $test_data_level"
echo ""


##### algorithm 
question=1
while [[ $question -gt 0 ]]; do

	echo -n "algorithm? [p]: PCR / [s]: SVM "

	tty_state=$(stty -g)
	stty raw
	char=$(dd bs=1 count=1 2> /dev/null)
	stty "$tty_state"

	echo

	case "$char" in
		[pP])
			algorithm="pcr"      
			question=$[ $question - 1 ]
		;;
		[sS])
			algorithm="svm"
      			question=$[ $question - 1 ]
		;;
	
    *)
      exit 1
    ;;
	esac
done

echo "Your choice is $algorithm"
echo ""

##### spatial scale
PS3='Mask: '

mask_list="
gray_matter
NPS
lada_whole
lada_all_regions
lada_aMCC
lada_AMOp
lada_AMIns
lada_BG
lada_dlPFC
lada_dpIns
lada_leftCERB
lada_MT
lada_pMCC
lada_PCun
lada_rightCERB
lada_S2
lada_SMA
lada_SMC
lada_LThal
lada_MThal
lada_upperBS
lada_vermis
lada_visual
lada_vlPFC
lada_vmPFC 
"

select mask in $mask_list
do
	case "$REPLY" in
	1)
		mask_type="gray"
		echo "Your choice is: $mask_type"
		break
		;;
	2)
		mask_type="nps"
		echo "Your choice is: $mask_type"
		break
		;;
	3)
		mask_type="lada_whole"
		echo "Your choice is: $mask_type"
		break
		;;
	4)
		mask_type="lada_all_regions"
		echo "Your choice is: $mask_type"
		break
		;;
	5)
		mask_type="lada_aMCC"
		echo "Your choice is: $mask_type"
		break
		;;
	6)
		mask_type="lada_AMOp"
		echo "Your choice is: $mask_type"
		break
		;;
	7)
		mask_type="lada_AMIns"
		echo "Your choice is: $mask_type"
		break
		;;
	8)
		mask_type="lada_BG"
		echo "Your choice is: $mask_type"
		break
		;;
	9)
		mask_type="lada_dlPFC"
		echo "Your choice is: $mask_type"
		break
		;;
	10)
		mask_type="lada_dpIns"
		echo "Your choice is: $mask_type"
		break
		;;
	11)
		mask_type="lada_leftCERB"
		echo "Your choice is: $mask_type"
		break
		;;
	12)
		mask_type="lada_MT"
		echo "Your choice is: $mask_type"
		break
		;;
	13)
		mask_type="ladapMCC"
		echo "Your choice is: $mask_type"
		break
		;;
	14)
		mask_type="lada_PCun"
		echo "Your choice is: $mask_type"
		break
		;;
	15)
		mask_type="lada_rightCERB"
		echo "Your choice is: $mask_type"
		break
		;;
	16)
		mask_type="lada_S2"
		echo "Your choice is: $mask_type"
		break
		;;
	17)
		mask_type="lada_SMA"
		echo "Your choice is: $mask_type"
		break
		;;
	18)
		mask_type="lada_SMC"
		echo "Your choice is: $mask_type"
		break
		;;
	19)
		mask_type="lada_LThal"
		echo "Your choice is: $mask_type"
		break
		;;
	20)
		mask_type="lada_MThal"
		echo "Your choice is: $mask_type"
		break
		;;
	21)
		mask_type="lada_upperBS"
		echo "Your choice is: $mask_type"
		break
		;;
	22)
		mask_type="lada_vermis"
		echo "Your choice is: $mask_type"
		break
		;;
	23)
		mask_type="lada_visual"
		echo "Your choice is: $mask_type"
		break
		;;
	24)
		mask_type="lada_vlPFC"
		echo "Your choice is: $mask_type"
		break
		;;
	25)
		mask_type="lada_vmPFC"
		echo "Your choice is: $mask_type"
		break
		;;
	*)
		echo "Error: Unknown Command"
		exit
		;;
	esac

	echo
done

echo ""

####### Sample split
PS3='Training sample size: '

split_list="
10
20
30
40
50
60
70
80
50:50
"

select split in $split_list
do
	case "$REPLY" in
		
		1)
			split=10
			echo "Your choice is: $split"
			break
			;;
		2)
			split=20
			echo "Your choice is: $split"
			break
			;;
		3)
			split=30
			echo "Your choice is: $split"
			break
			;;
		4)
			split=40
			echo "Your choice is: $split"
			break
			;;
		5)
			split=50
			echo "Your choice is: $split"
			break
			;;
		6)
			split=60
			echo "Your choice is: $split"
			break
			;;
		7)
			split=70
			echo "Your choice is: $split"
			break
			;;
		8)
			split=80
			echo "Your choice is: $split"
			break
			;;
		9)
			split="50:50"
			echo "Your choice is: $split"
			break
			;;

		*)
			echo "Error: Unknown Command"
			exit
			;;
	esac

	echo
done

echo ""


read -p "Tag? (ex.210904)  " tag 

echo ""
echo "================================="
echo "Check the variables!!!"
echo "+train data level: " $train_data_level
echo "+test data level: " $test_data_level
echo "+algorithm: " $algorithm
echo "+mask: " $mask_type
echo "+split: " $split
echo "+tag: " $tag
echo "================================="


#### Final qustion
while true
do
	read -r -p "Do you want to continue? (y/n) " choice
                case "$choice" in
                        n|N) exit 111;;
                        y|Y) break;;
                        *) echo "Response not valid";;
                esac
done

allregions="
lada_aMCC
lada_AMOp
lada_AMIns
lada_BG
lada_dlPFC
lada_dpIns
lada_leftCERB
lada_MT
lada_pMCC
lada_PCun
lada_rightCERB
lada_S2
lada_SMA
lada_SMC
lada_LThal
lada_MThal
lada_upperBS
lada_vermis
lada_visual
lada_vlPFC
lada_vmPFC 
"

if [ "${mask_type}" = "lada_all_regions" ]; then

	echo "All 21 regions!"
	count_n=0
	for region in $allregions
	do
		let "count_n+=1"
		log_date=$(date '+%Y%m%d-%H%M%S')
		log_file=$(printf '/home/donghee/Documents/MATLAB/log/lpp_analysis_%s-%s.log' "${log_date}" "$count_n")
		
		nohup matlab -sd "/home/donghee/das/dropbox/projects/LPP/sync/scripts/image" -batch "LPP_analysis('train_data_level', '$train_data_level', 'test_data_level', '$test_data_level', 'algorithm', '$algorithm', 'mask_type', '$region', 'split', '$split', 'tag', '$tag')" > "$log_file" 2>&1 </dev/null &

	done	
else

	log_date=$(date '+%Y%m%d-%H%M%S')
	log_file=$(printf '/home/donghee/Documents/MATLAB/log/lpp_analysis_%s.log' "${log_date}")
	
	nohup matlab -sd "/home/donghee/das/dropbox/projects/LPP/sync/scripts/image" -batch "LPP_analysis('train_data_level', '$train_data_level', 'test_data_level', '$test_data_level', 'algorithm', '$algorithm', 'mask_type', '$mask_type', 'split', '$split', 'tag', '$tag')" > "$log_file" 2>&1 </dev/null &

fi

echo "=============END==============="

exit 0
