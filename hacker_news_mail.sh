#!/bin/bash

SUBJECT="HN Hot Story"
NAME="Hacker News"

RECIPIENTS="$1"

CONTENT=$(curl -s 'https://news.ycombinator.com/' | tr -cd '[:print:]' | xmllint --html --xpath '//span[@class="score"]/text() | //a[@class="storylink"]' - 2>/dev/null | awk '$1 ~ /^[0-9]+$/ && $1 > 700 {print prev_line,$1 + " points"} {prev_line=$0}')
[[ -z "$CONTENT" ]] && exit

# LINK="$(echo "$CONTENT" | rev | cut -d' ' -f2- | rev)"
# grep -q "$LINK" /tmp/hn_tmp && exit
# echo "$LINK" >> /tmp/hn_tmp

wrap_html() {
    printf "Subject: %s\r\nContent-Type: text/html\r\n\r\n<pre style=\"white-space=pre!important;font-size:1em;background-color:#f6f6ef;\">%s</pre>" "$1" "$2"
}

wrap_html "$SUBJECT" "$CONTENT" | /usr/sbin/ssmtp "$RECIPIENTS" -F "$NAME"
