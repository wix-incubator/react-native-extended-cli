port=$1

if !([[ -n $port ]];) then
    echo No port argument provided.
    exit
fi

pid=$(lsof -t -i4TCP:$port)
if [[ -n $pid ]]; then
    echo Killing $pid on port: $port
    kill -9 $pid
else
    echo Port $port is free
fi
