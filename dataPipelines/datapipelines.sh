#!/bin/bash

#creating a new file name daily
special_case="false"
date=`date +%m-%d-%Y`
file_name="${date}_Dataset.csv"
touch $file_name

#defining column names
cat > $file_name <<EOF
first_name, last_name, price, above_100

EOF

#counter 1 because I want to use it for the for loop condition
counter=1
{
read
while read line;
    do
	#if line contains "," , means it has both name and price hence proceed, else skip line
    if [[ ${line} == *","* ]];then
        
        for i in $(echo $line | sed "s/,/ /g")
        
        do
            #this is to go to next line
            if [[ $counter -eq 3 ]] && [[ "$i" =~ ^[0-9]*(\.[0-9]+)?$ ]]
            then
                if [[ "$special_case" = "true" ]]; then
                    #remove prepending zeroes
                    echo -n  $i | sed 's/^0*//' >> $file_name
                    echo  -n ", " >> $file_name
                    
                    counter=1
                    number_of_lines=($(wc $file_name))
                    lines=${number_of_lines[0]}
                    lines=$(( $lines - 1))
                    #merging last 2 lines
                    sed -i.bak "$lines{N;s/\n//;}" $file_name
                    special_case="false"
                    if awk "BEGIN {exit $i >= 100 ? 0 : 1}"
                    then
                        echo "true" >> $file_name
                    else
                        echo  "false" >> $file_name
                    fi
                    number_of_lines=($(wc $file_name))
                    lines=${number_of_lines[0]}
                    lines=$(( $lines - 2))
                    #merging last 2 lines
                    sed -i.bak "$lines{N;s/\n//;}" $file_name
                    
                    number_of_lines=($(wc $file_name))
                    lines=${number_of_lines[0]}
                    lines=$(( $lines - 1))
                    #merging last 2 lines
                    sed -i.bak "$lines{N;s/\n//;}" $file_name
                else
                #remove prepending zeroes 
                    echo  -n  $i | sed 's/^0*//' >> $file_name
                    echo  -n ", " >> $file_name
                    counter=1
                    if awk "BEGIN {exit $i >= 100 ? 0 : 1}"
                    then
                        echo  "true" >> $file_name
                    else
                        echo  "false" >> $file_name
                    fi
                    number_of_lines=($(wc $file_name))
                    lines=${number_of_lines[0]}
                    lines=$(( $lines - 1))
                    #merging last 2 lines
                    sed -i.bak "$lines{N;s/\n//;}" $file_name
                fi
            elif [[ $counter -eq 3 ]] && ! [[ "$i" =~ ^[0-9]*(\.[0-9]+)?$ ]]
            then
                sed -i.bak "$ s/.$//" $file_name
                sed -i.bak "$ s/.$//" $file_name
                echo -n " " >> $file_name
                echo -n $i >> $file_name
                echo  -n ", " >> $file_name
                number_of_lines=($(wc $file_name))
				lines=${number_of_lines[0]}
                #merging last 2 lines 
                sed -i.bak "$lines{N;s/\n//;}" $file_name
                special_case="true"
            else
                # for those Dr. or Mr.
                if [[ ${i} == *"."* ]];then
                    echo -n $i >> $file_name
                    echo -n " " >> $file_name
					
				else
                    echo -n $i >> $file_name
                    echo  -n ", " >> $file_name
                    counter=$((counter+1))
                fi
            fi
        done
    fi
done } < dataset.csv
