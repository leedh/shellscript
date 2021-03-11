#!/bin/bash

echo ""
echo "===This script will compare the number of files between two directories ==="
echo ""
echo ""
echo ": for example, "
echo ": Main      : /backup_drive/A/"
echo ": Reference : /local_computer/A"
echo ""
echo ""

read -p "Enter the path of main directory : " DIR1

if [ ${DIR1: -1} != / ]
then
       DIR1=$DIR1/
fi       

read -p "Enter the path of reference directory : " DIR2

if [ ${DIR2: -1} != / ]
then
	DIR2=$DIR2/
fi


# the number of files
DIR1_N=(`ls -1 $DIR1 | wc -l`)
DIR2_N=(`ls -1 $DIR2 | wc -l`)

echo "The number of directories in Main      : " $DIR1_N
echo "The number of directories in Reference : " $DIR2_N

if [ $DIR1_N -ne $DIR2_N ]
then
	echo "The number of subdir is different!!"
	while true
	do
		read -r -p "Do you want to continue? (y/n) " choice
		case "$choice" in
			n|N) exit 111;;
			y|Y) break;;
			*) echo "Response not valid";;
		esac
	done
else
	echo "The number of subdir is the same!!"
fi


readarray -t DIR1_SUBDIR < <(find $DIR1 -maxdepth 1 -type d -printf '%P\n')
#readarray -t DIR2_SUBDIR < <(find $DIR2 -maxdepth 1 -type d -printf '%P\n')

echo "Will Compare directories below.."
for dir in ${DIR1_SUBDIR[@]}
do
	echo "-> " $dir
done

#echo "Will Compare these directories : " ${DIR1_SUBDIR[@]}
#echo "dir2_subdir : " ${DIR1_SUBDIR[@]}

while true
do
	read -r -p "Do you want to continue? (y/n) " choice
                case "$choice" in
                        n|N) exit 111;;
                        y|Y) break;;
                        *) echo "Response not valid";;
                esac
done


echo ""
echo ""
echo "Now.....comapring is starting........."
echo ""
echo ""

MISSING_DIR=()

# compare base drictoriy
# compare sub directories
for dir in ${DIR1_SUBDIR[@]}
do

	DIR1_fn=$(find $DIR1$dir -type f | wc -l)
	DIR2_fn=$(find $DIR2$dir -type f | wc -l)

	if [ $DIR1_fn -eq $DIR2_fn ]
	then
		echo "..." $dir " is done..."
	else
		echo "Two sub directories of " $dir " have different number of files."
		MISSING_DIR+=($dir)
	fi

done

echo ""
echo ""
echo "---------------------------------------------------------"
echo "Below is the sub directories that mismatched each other."
echo ${MISSING_DIR[@]}
echo ""
echo ""
echo "----END----."
exit 0

			
		
			
