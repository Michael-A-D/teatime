#!/bin/bash

declare -A timer info

clock=⌚
moon=☾
sun=☼
celsius=℃
bell=☼☼

timer[himalaya]=240
info[himalaya]="90$celsius | 4' $clock | $bell"

timer[oolong]=360
info[oolong]="95$celsius | 5'-7' $clock | $moon"

timer[blue-of-london]=270
info[blue-of-london]="95$celsius | 4'-5' $clock | $sun"

timer[long-jing]=210
info[long-jing]="75$celsius | 3'-4' $clock | $sun"

timer[sencha]=90
info[sencha]="60$celsius | 1'-2' $clock | $sun"

timer[rooibos]=300
info[rooibos]="90$celsius | 5' $clock | $moon"

timer[tigre]=270
info[tigre]="90$celsius | 4-5' $clock | $sun"

timer[moines]=180
info[moines]="95$celsius | 3' $clock | $sun"

notify (){
    title=$1
    message=$2
    icon=$3
    time=$4
    notify-send "$title" "$message" -i $icon -t $time
    if [[ $message == "" ]] ; then
        echo -e "$title";
    else
        echo -e "$title:\n$message"
    fi | sed "s/$clock/min/g;s/$bell/matin/g;s/$moon/soir/g;s/$sun/journée/g;s/$celsius/°C/g"
}

if [[ $# -eq 2 && $1 == "-i" && $2 -ne "" ]]; then
    kind=$2
    if [[ -n ${timer[$kind]+1} ]]; then
        info="$kind: ${info[$kind]}"
        notify "$info" "" info 10000
        exit 0
    else
        unknown="Unknown tea $kind, chose one of:"
        for i in $(echo ${!timer[@]} | sed  "s/ /\n/g" | sort); do
            unknown+="\n* $i"
        done
        notify "Tea timer error" "$unknown" dialog-error 5000
        exit 2
    fi
fi

if [[ $# -ne 1 || $1 == "" ]]; then
    usage="Usage: teatime [-i] kind"
    usage+="\nwhere kind is one of:"
    for i in $(echo ${!timer[@]} | sed  "s/ /\n/g" | sort); do
        usage+="\n* $i"
    done
    notify "Tea timer error" "$usage" dialog-error 5000
    exit 1
fi

kind=$1

if [[ -n ${timer[$kind]+1} ]]; then
    notify "Timer started" "$kind ready in ${timer[$kind]} seconds" appointment-new 5000
    sleep $(( ${timer[$kind]} - 10 ))
    notify "Timer over soon" "$kind ready in 10 seconds" appointment-soon 5000
    sleep 10
    notify "Timer over" "$kind ready!" appointment-missed 10000
    exit 0
else
    unknown="Unknown tea $kind, chose one of:"
    for i in $(echo ${!timer[@]} | sed  "s/ /\n/g" | sort); do
        unknown+="\n* $i"
    done
    notify "Tea timer error" "$unknown" dialog-error 5000
    exit 2
fi
