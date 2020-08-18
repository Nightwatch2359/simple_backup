#!/bin/bash
#
# Dieses Script legt 9 Generationen des htdocs-Verzeichnisses unter Nutzung von Hardlinks an
#
declare -a BACKUPDIR
ROOTDIR=~
DIRECTORY=pkg
export GENERATIONS=9

SOURCEDIR=${ROOTDIR}/${DIRECTORY}

for I in $(seq $GENERATIONS -1 0)
do
  BACKUPDIR[I]=${ROOTDIR}/.${DIRECTORY}.${I}
  # echo ${BACKUPDIR[$I]}
done

# letzte Generation löschen
[ -d ${BACKUPDIR[$GENERATIONS]} ] && rm -rf ${BACKUPDIR[$GENERATIONS]}

# Generationen 1-8 um eins verschieben
GEN_MINUS1=$(($GENERATIONS - 1))
for I in $(seq $GEN_MINUS1 -1 1) 
do
  J=$(($I + 1))
  [ -d ${BACKUPDIR[$I]} ] && mv ${BACKUPDIR[$I]} ${BACKUPDIR[$J]}
done

# Generation 0 per Hardlink nach Gen 1 kopieren
[ -d ${BACKUPDIR[0]} ] && cp -al ${BACKUPDIR[0]} ${BACKUPDIR[1]}

# Source nach Gen 0 kopieren
rsync -q -av -H --delete $SOURCEDIR/* ${BACKUPDIR[0]}

# Backupdir 0 mit Zeitstempel versehen
touch ${BACKUPDIR[0]}
