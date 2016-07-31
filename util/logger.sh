if [ "${IS_BUILD_AGENT}" == true ]; then
    if [ "$1" == "buildStatus" ]; then
        echo "##teamcity[buildStatus status='$2' text='$2']"
    else
        echo "##teamcity[$1 name=$2]"
    fi
fi
