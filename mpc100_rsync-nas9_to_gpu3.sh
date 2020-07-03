#!/bin/bash

# project : MPC100

projectname="MPC100"

rsync_dir="/home/donghee/Documents/rsync"

# HPC/NAS 09 -> GPU3 DAS (update//no delete option)

srcenvname="nas09"

dstenvname="gpu3"

#nas09
srcaccount="user@ip_address"
srcpw="yourpassword"

expect_char="password"



echo ""
echo "================= RUN rsync ================="
echo ""
echo "${projectname} rsync is starting..."

question=1

while [[ $question -gt 0 ]]; do

	echo -n "which one do you sync? data:[d] / project:[p] "

	tty_state=$(stty -g)
	stty raw
	char=$(dd bs=1 count=1 2> /dev/null)
	stty "$tty_state"

	echo

	case "$char" in
		[dD])
      srcdir="/volume2/COCOAN/GPU3_sync/data/MPC/MPC_100/"
      dstdir="/media/das/dropbox/data/MPC/MPC_100/"
			question=$[ $question - 1 ]
		;;
		[pP])
      srcdir="/volume2/COCOAN/GPU3_sync/projects/MPC/MPC_100/"
      dstdir="/media/das/dropbox/projects/MPC/MPC_100/"
      question=$[ $question - 1 ]
		;;
    *)
      exit 1
    ;;
	esac
done

echo "=========================================="


echo "Source : ${srcenvname}"
echo "Source Path : ${srcdir}"
echo ""
echo "Destination : ${dstenvname}"
echo "Destination Path : ${dstdir}"
echo ""


echo -n "Continue to rsync? Yes:[y] / No:[any]"

tty_state=$(stty -g)
stty raw
char=$(dd bs=1 count=1 2> /dev/null)
stty "$tty_state"

echo


case "$char" in
  [yY])
    echo "Start rsync..."
  ;;
  *)
    echo "Break rsync...Bye..."
    exit 1
  ;;
esac


if [ ! -d "${rsync_dir}/log" ]; then
  mkdir "${rsync_dir}/log"
fi

rsync_log=$rsync_dir/log/rsync_$(date "+%Y-%m-%d").log


echo "" >> $rsync_log
echo "" >> $rsync_log
echo "*************" $(date "+%Y-%m-%d %H:%M:%S") "*************" >> $rsync_log
echo "" >> $rsync_log
echo "Source : ${srcenvname}" >> $rsync_log
echo "Source Path : ${srcdir}" >> $rsync_log
echo ""
echo "Destination : ${dstenvname}" >> $rsync_log
echo "Destination Path : ${dstdir}" >> $rsync_log
echo "" >> $rsync_log



SECONDS=0
start_time=$SECONDS

# rsync command!!
rsync_command="rsync -rltvupO --partial --chmod=Dugo=rwx,Fugo=rwx --exclude=.* --exclude=@eaDir $srcaccount:$srcdir $dstdir"

expect -c "
set timeout -1
spawn $rsync_command
expect {
-nocase \"$expect_char\" {send \"$srcpw\\r\"}
}
expect eof
" >> $rsync_log


elapsed_time=$((SECONDS-start_time))


echo "" >> $rsync_log
echo "" >> $rsync_log
printf 'rsync is done (elapsed_time: %d hrs, %d mins, %d secs).\n' $((elapsed_time/3600)) $((elapsed_time%3600/60)) $((elapsed_time%60)) >> $rsync_log
echo "" >> $rsync_log
echo ""
echo "================= FINISH rsync ================="
echo ""

chmod 777 $rsync_log
