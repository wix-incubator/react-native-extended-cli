echo Initialling React Native project $1 with version $2

rninit init $1 --source react-native@$2

rnxRoot=${BASH_SOURCE[0]%/*}/../react-native-extended-cli

if [ ! -d "$rnxRoot" ]; then
    rnxRoot=${BASH_SOURCE[0]%/*}/../lib/node_modules/react-native-extended-cli
fi

cp -r rnxRoot/template/ ./ 