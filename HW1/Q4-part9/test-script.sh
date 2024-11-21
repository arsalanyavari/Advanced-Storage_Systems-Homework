#! /usr/bin/env bash
sudo -v

fio test.fio > before-remove.txt

sudo mdadm --manage /dev/md5 --fail /dev/sdf1 & \
    fio test.fio > during-remove.txt

fio test.fio > after-remove.txt

sudo mdadm --manage /dev/md5 --remove /dev/sdf1 && sudo mdadm --manage /dev/md5 --add /dev/sdf1 \
    && fio test.fio > during-recovery.txt


echo "Results:"

cat before-remove.txt | grep read: | awk '{printf "IOPS and BW before remove any disk:\n%s %s\n", $2, $3}'

cat during-remove.txt | grep read: | awk '{printf "IOPS and BW during remove a disk:\n%s %s\n", $2, $3}'

cat after-remove.txt | grep read: | awk '{printf "IOPS and BW after remove a disk:\n%s %s\n", $2, $3}'

cat during-recovery.txt | grep read: | awk '{printf "IOPS and BW during recovery raid array:\n%s %s\n", $2, $3}'

