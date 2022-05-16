#! /bin/bash

operation="$1"
shift

if [ $operation == "add" ]; then
  title=""
  hasTitle=false
  hasPriority=false
  priority="L"
  while [ -n "$1" ]
  do
    case "$1" in 
      -t | --title) title="$2"
      hasTitle=true
      shift
      shift ;;
      -p | --priority) priority="$2"
      hasPriority=true
      shift
      shift ;;
      *) echo "$1 is not an option"
      shift ;;
    esac
  done
  if [ "$hasTitle" == false ] || [ -z "$title" ]; then
    echo "Option -t|--title Needs a Parameter"
  elif [ $hasPriority == true ] && [ "$priority" != "H" ] && [ "$priority" != "L" ] && [ "$priority" != "M" ]; then
    echo "Option -p|--priority Only Accept L|M|H"
  else
    echo 0,$priority,\"$title\" >> tasks.csv
  fi
elif [ $operation == "find" ]; then
  pattern=$1
  cat tasks.csv | awk -F "," 'BEGIN{i=1} {print i " | " $1 " | " $2 " | " $3; i++}' | grep "$pattern"
elif [ $operation == "done" ]; then
  num=$1
  file=tasks.csv
  tmp_line=$(sed -n "$num"p "$file")
  line="1"${tmp_line:1}
  sed -i "$num""s/$tmp_line/$line/" "$file"
elif [ $operation == "list" ]; then
  cat tasks.csv | awk -F "," 'BEGIN{i=1} {print i " | " $1 " | " $2 " | " $3; i++}'
elif [ $operation == "clear" ]; then
  > tasks.csv
else
  echo "Command Not Supported!"
fi
