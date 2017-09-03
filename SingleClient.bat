cd C:\mongo\bin
mongoexport --db ibank-log --collection log  -q "{"client_id" : "3831"}" -o C:\tmp\08072015.csv
