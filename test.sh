#!/bin/bash

read -r -d '' MESSAGE << EOM
#     #    #    #     #    #    #     #    #   
#     #   # #   #     #   # #   #     #   # #  
#     #  #   #  #     #  #   #  #     #  #   # 
####### #     # ####### #     # ####### #     #
#     # ####### #     # ####### #     # #######
#     # #     # #     # #     # #     # #     #
#     # #     # #     # #     # #     # #     #
EOM

# Initial Sunday of the year
INITIAL="2015-01-04"

WEEK=0
DAY=0
for (( i=0; i<${#MESSAGE}; i++ )); do

  CHAR="${MESSAGE:$i:1}"
  if [[ $CHAR == "#" ]]; then
    WEEK_ADDITION=""
    DAY_ADDITION=""
    if (( $WEEK > O )); then
        WEEK_ADDITION="-v +${WEEK}w"
    fi
    if (( $DAY > 0 )); then
        DAY_ADDITION="-v +${DAY}d"
    fi
    echo "week $WEEK_ADDITION"
    echo "day $DAY_ADDITION"
    COMMIT_DATE=$(date -j ${WEEK_ADDITION} ${DAY_ADDITION} -f "%Y-%m-%d" "$INITIAL" +%F)
    COMMIT_DATE_TIME="${COMMIT_DATE} 12:00:00"
    echo "Need commit at $COMMIT_DATE"

    echo "$i on $COMMIT_DATE" >> commit.md
    export GIT_COMMITTER_DATE="$COMMIT_DATE_TIME"
    export GIT_AUTHOR_DATE="$COMMIT_DATE_TIME"
    echo "committer date: $GIT_COMMITTER_DATE"
    git add commit.md -f
    git commit --date="$COMMIT_DATE_TIME" -m "$i on $COMMIT_DATE"
  fi
  if [[ $CHAR == $'\n' ]]; then
    echo "Got new line at $i"
    WEEK=0
    ((DAY=$DAY+1))
  fi
  ((WEEK=$WEEK+1))
done

git push origin main
# git rm -rf commit.md
# git commit -am "cleanup"
# git push origin main