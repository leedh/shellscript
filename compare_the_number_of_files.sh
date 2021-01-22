#!/bin/bash

echo ""
echo "===This script will compare the number of files between two directories ==="
echo ""
echo ""
echo ": for example, "
echo ": Directory 1 : /media/das/dropbox/data/MPC/imaging/dicom_from_scanner/"
echo ": Directory 2 : /media/das/backup/dicom_from_scanner/"
echo ""
echo ""

read -p "Enter the path of one directory : " DIR1
#DIR1="/media/das/MPC100_dicom_backup/dicom_from_scanner/"

read -p "Enter the path of the other directory : " DIR2
#DIR2="/media/cocoan_mri/dicom_from_scanner/MPC100/"

# the number of files
DIR1_N=(`ls -1 $DIR1 | wc -l`)
DIR2_N=(`ls -1 $DIR2 | wc -l`)

echo "The number of directories in DIR1 : " $DIR1_N
echo "The number of directories in DIR2 : " $DIR2_N

readarray -t DIR1_SUBDIR < <(find $DIR1 -maxdepth 1 -type d -printf '%P\n')
readarray -t DIR2_SUBDIR < <(find $DIR2 -maxdepth 1 -type d -printf '%P\n')

#echo "dir1_subdir : " ${DIR1_SUBDIR[@]}
#echo "dir2_subdir : " ${DIR1_SUBDIR[@]}

echo ""
echo "Now.....comapring is starting........."
echo ""
echo ""

MISSING_DIR=()

# compare base drictoriy
if [ $DIR1_N -eq $DIR2_N ]
then
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
else
	echo "Two base directories have differernt number of sub directories."
fi

echo ""
echo ""
echo "---------------------------------------------------------"
echo "Below is the sub directories that mismatched each other."
echo ${MISSING_DIR[@]}
echo ""
echo ""
echo "----END----."
exit 0

			
		
			
