#!/bin/bash


read -p "Enter the path of source directory : " DIR1

if [ ${DIR1: -1} != / ]
then
       DIR1=$DIR1/
fi

read -p "Enter the path of destination directory : " DIR2
if [ ${DIR2: -1} != / ]
then
        DIR2=$DIR2/
fi


# the number of files
DIR1_N=(`ls -1 $DIR1 | wc -l`)
DIR2_N=(`ls -1 $DIR2 | wc -l`)

echo "The number of directories in Source      : " $DIR1_N
echo "The number of directories in Destination : " $DIR2_N

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
fi

readarray -t DIR1_SUBDIR < <(find $DIR1 -maxdepth 1 -type d -printf '%P\n')
readarray -t DIR1_SUBSUBDIR < <(find $DIR1${DIR1_SUBDIR[1]} -maxdepth 1 -type d -printf '%P\n')


echo "Below is the dir list of one directory in subdir.." ${DIR1_SUBDIR[1]}
for dir in ${DIR1_SUBSUBDIR[@]}
do
        echo "-> " $dir
done

read -p "What directory do you want to copy? : " COPYDIR

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
echo "Now.....copying is starting........."
echo ""
echo ""


for dir in ${DIR1_SUBDIR[@]}
do
	if [ -d $DIR1$dir ]
	then
		cp -R $DIR1$dir/$COPYDIR $DIR2$dir 
	fi
done

echo ""
echo ""
echo ""
echo ""
echo "----END----."
exit 0
