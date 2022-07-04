#!/bin/sh

ROOT="/home/git"
REPOS="DragonFlyBSD FreeBSD linux"
LOG=$ROOT/repos-sync.log
WTROOT=$ROOT/work-tree
SEP="--------------------------------"

echo $SEP >> $LOG
date >> $LOG
echo $SEP >> $LOG
for r in $REPOS
do
    cd $ROOT/$r
    changed=1
    desc=`cat description`
    echo "sync ..." > description
    WT=$WTROOT/$r
    mkdir -p ${WT}
    git config pull.rebase false
    git --work-tree=${WT} clean -fd
    git --work-tree=${WT} checkout --force
    git --work-tree=${WT} pull | grep -q "Already up to date" && changed=0
    if [ $changed = 1 ]
    then
        echo "["$r"] pull" >> $LOG
        echo `date +"%D %T %Z"` > description
    else
        echo $desc > description
        echo "["$r"] Already up to date" >> $LOG
    fi
done

echo $SEP >> $LOG
echo "" >> $LOG
