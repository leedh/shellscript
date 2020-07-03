#!/bin/bash

# BACK UP :: Copy DICOM data from NAS05 to GPU3_DAS


subj_info_question=1

while [[ $subj_info_question -gt 0 ]]; do
	#read -p "Enter your project name (ex. MPC) : " projectname
	#projectname=${projectname^^}
	projectname='MPC'
	read -p "Enter the initial of the subject name (ex. LDH) :  " subjname
	subjname=${subjname^^}
	read -p "Enter the subject ID number (ex. 61) : " subjID
	subjID=$(printf '%03d' "${subjID}")

	subject="${projectname}${subjID}_${subjname}"
	dirname="${subjname}_${projectname}${subjID}"

	echo -e ">>>directory name is \033[47;31m$dirname\033[0m"

	echo "==============================="

	echo -n "is that right?(ex. LDH_MPC061) [Y/N] : "

	tty_state=$(stty -g)
	stty raw
	char=$(dd bs=1 count=1 2> /dev/null)
	stty "$tty_state"

	echo

	case "$char" in
		[yY])
			subj_info_question=$[ $subj_info_question - 1 ] # finish subject info question!
		;;
		[nN])
			echo -n "type agian?[T] or quit?[Q] : "

			tty_state=$(stty -g)
			stty raw
			char=$(dd bs=1 count=1 2> /dev/null)
			stty "$tty_state"

			echo

			case "$char" in
				[tT])
				echo "==============================="
				echo "type subject info again!"
				;;
				[qQ])
				exit 1
				;;
			esac
		;;
	esac
done

echo "==============================="


subj_info_question=1

while [[ $subj_info_question -gt 0 ]]; do

	read -p "Enter the year you did scan for $subject (ex. 2020) : " scanyear
	read -p "Enter the month you did scan for $subject (1~12) : " scanmonth
	scanmonth=$(printf '%02d' "${scanmonth}")
	scandate="${scanyear}_${scanmonth}"

	echo -e ">>>the date is \033[47;31m$scandate\033[0m"

	echo "==============================="

	echo -n "is that right?(ex. 2020_01) [Y/N] : "

	tty_state=$(stty -g)
	stty raw
	char=$(dd bs=1 count=1 2> /dev/null)
	stty "$tty_state"

	echo

	case "$char" in
		[yY])
			subj_info_question=$[ $subj_info_question - 1 ] # finish subject info question!
		;;
		[nN])
			echo -n "type agian?[T] or quit?[Q] : "

			tty_state=$(stty -g)
			stty raw
			char=$(dd bs=1 count=1 2> /dev/null)
			stty "$tty_state"

			echo

			case "$char" in
				[tT])
				echo "==============================="
				echo "type subject info again!"
				;;
				[qQ])
				exit 1
				;;
			esac
		;;
	esac
done

echo "==============================="


currentyear=$(date +%Y)
currentmonth=$(date +%m)
currentdate="${currentyear}_${currentmonth}"


nas05_dir="/media/cnir05"
gpu3_dir="/media/das/dropbox/data/$projectname/MPC_100/imaging/dicom_from_scanner"


if [ $scandate = $currentdate ]; then
	src_dir="${nas05_dir}/${dirname}/"
	dst_dir="${gpu3_dir}/${subject}"

	if [ -d $src_dir ]; then
		if rsync -au --info=progress2 $src_dir $dst_dir ; then

			src_filecount=$(find "$src_dir" -type f -print | wc -l)
			dst_filecount=$(find "$dst_dir" -type f -print | wc -l)

			if [ $src_filecount = $dst_filecount ]	; then
				echo "rsync is successfully done without file loss!"
			else
				echo "rsync done, but missing some files. Please check!!"
			fi
		else
			echo "Error: rsync error!!"
		fi
	else
		echo "Error : the source directory path is wrong!"
		echo "check '${src_dir}'"
		exit 1
	fi
else
	src_dir="${nas05_dir}/${scandate}/${dirname}/"
	dst_dir="${gpu3_dir}/${subject}"

	if [ -d $src_dir ]; then
		if rsync -au --info=progress2 $src_dir $dst_dir ; then

			src_filecount=$(find "$src_dir" -type f -print | wc -l)
			dst_filecount=$(find "$dst_dir" -type f -print | wc -l)

			if [ $src_filecount = $dst_filecount ]	; then
				echo "rsync is successfully done without file loss!"
			else
				echo "rsync done, but missing some files. Please check!!"
			fi

		else
			
			echo "Error: rsync error!"
		fi
	else
		echo "Error : the source directory path is wrong!"
		echo "check '${src_dir}'"
		exit 1
	fi
fi
