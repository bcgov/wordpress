#!/bin/sh


scan() {
  regex=$1
  file=$2
  echo "Analyzing for ${regex} > $(pwd)/.audit/${file}"
  egrep -rni \
  --exclude-dir=.audit \
  --exclude-dir=.phpdocs \
  --exclude-dir=node_modules \
  --exclude-dir=.git \
  --exclude-dir=tests \
  --exclude composer\.lock \
  --exclude \*.xml \
  --exclude \*.txt \
  --exclude \*.md \
  --exclude \*.lock \
  --exclude \*.json \
  "${regex}" \
  $(pwd) \
  | cut -b 1-250 \
  > $(pwd)/.audit/${file}
}


init() {
  directory=$(pwd)/.audit
  if [ ! -d "$directory" ]; then
    echo "Making audit directory $directory"
    mkdir $directory
  fi

  if  grep -q '\.audit' "$(pwd)/.gitignore" ; then
      echo "NO ACTION  .audit already in .gitignore"
  else
      echo "Adding .audit to .gitignore"
      echo '.audit' >> $(pwd)/.gitignore
  fi
  echo "\n\n"
}

echo "\n-------------------------------"
echo "| BCGov Audit                 |"
echo "-------------------------------\n"
init

scan  'google' 'google-audit.txt'
scan '(jquery\.ajax|jquery\.post|jquery\.get|\$\.ajax|\$\.post|\$\.get|fetch)' 'jquery-post.txt'
scan '(\<script\>|src\=)' 'script.txt'
scan '(https|http|ftp|sftp)\:\/\/' 'urls.txt'
scan '(curl|http_response|wp_remote)' 'http_response.txt'
scan '(\s+db|\$wpdb|mysql|sql|connect)' 'db.txt'
## the escaping of hex values might not be correct.
scan '(zip|eval|chmod|exec)' 'malicious.txt'
scan '(b\s*a\s*s\s*e\s*6\s*4|\\x65\\x76\\x61\\x6C|\\x62\\x61\\x73\\x65\\x36\\x34\\x5F\\x64\\x65\\x63\\x6F\\x64\\x65)' 'base64.txt'
scan '(\$\_POST|\$\_GET|\$\_REQUEST)' 'REQUEST.txt'

find ../ -type f -name \*.zip > $(pwd)/.audit/archivefiles.txt
ls -lS $(pwd)/.audit
open -a 'Google Chrome' $(pwd)/.audit