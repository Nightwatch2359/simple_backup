#!/bin/bash
#
# Dieses Script legt 9 Generationen des htdocs-Verzeichnisses unter Nutzung von Hardlinks an
#
declare -a BACKUPDIR
ROOTDIR=/opt/bbk/was
#ROOTDIR=~
DIRECTORY=pkg

SOURCEDIR=${ROOTDIR}/${DIRECTORY}

for I in 0 1 2 3 4 5 6 7 8 9
do
  BACKUPDIR[I]=${ROOTDIR}/.${DIRECTORY}.${I}
  #echo ${BACKUPDIR[$I]}
done

# letzte Generation löschen
[ -d ${BACKUPDIR[9]} ] && rm -rf ${BACKUPDIR[9]}

# Generationen 1-8 um eins verschieben
for I in 8 7 6 5 4 3 2 1
do
  J=$(($I + 1))
  [ -d ${BACKUPDIR[$I]} ] && mv ${BACKUPDIR[$I]} ${BACKUPDIR[$J]}
done

# Generation 0 per Hardlink nach Gen 1 kopieren
[ -d ${BACKUPDIR[0]} ] && cp -al ${BACKUPDIR[0]} ${BACKUPDIR[1]}

# Source nach Gen 0 kopieren
rsync -q -av -H --delete $SOURCEDIR ${BACKUPDIR[0]}

# Backupdir 0 mit Zeitstempel versehen
touch ${BACKUPDIR[0]}
