#!/bin/bash

log="/home/donghee/Documents/shell_script/log"

root="/media/das/old_cocoanlab_Dropbox_201117/data/MPC/MPC_100/imaging/dicom_from_scanner"

for dic in $root/*
do 
	if [ -d $dic ]
	then
		subj="${dic: (-10)}"

		nohup tar cvf $dic.tar $dic >> $log/tar_dicom_$subj.txt 2>&1 </dev/null &
	fi
done

echo "done. check nohup"
