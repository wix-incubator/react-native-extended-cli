# check if a process is listening to the specified port
port=${1}
pid=`lsof -n -i:${port} | grep LISTEN | awk '{ print $2 }' | uniq`
if [ -z "${pid}" ]; then
  echo "[checkPort]: Port ${port} is free."
else
  echo "[checkPort]: WARNING! Port ${port} is taken by:\n`ps -vf -p ${pid}`"
fi
