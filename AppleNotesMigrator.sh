#!/bin/bash

### Apple Notes archiver ###

notes_location = "$HOME/Library/Group\ Containers/group.com.apple.notes/" 
notesDB = "$notes_location/NoteStore.sqlite"
if  [[ $(ls /Volumes | grep GoogleDrive) ]] ; then
        output_db="Volumes/GoogeDrive/NotesArchive"
        output_csv=output_db
        echo "Google Drive is not currently running. Notes will be saved as a plain spreadsheet to the Desktop and the database will be archived in Documents."
    else
        output_db="$HOME/Documents/NotesArchive"
        output_csv="$HOME/Desktop/Notes/"
        
fi

mkdir $output_db $output_csv
tar -czf $notes_location "$output_db"+$(date +'%Y_%m_%d').zip

# sqlite commands
sqlite3 $notesDB <<EOF
.mode csv
.output $output_location/Notes_out.csv
select ZTITLE1, ZSNIPPET from ZICCLOUDSYNCINGOBJECT where ZTITLE1 IS NOT NULL;
EOF