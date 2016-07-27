projectName=$1
rnVersion=$2

if [ "$rnVersion" == "" ]; then
    rnVersion="latest"
fi

echo Initialling React Native project $projectName with version: $rnVersion

rninit init $projectName --source react-native@$rnVersion

cd $projectName

cp -r $rnxRoot/template/ ./ 

jq -r '.version="1.0.0"
    | .main="src/module.js"
    | .scripts.build="rnx build"
    | .scripts.release="rnx release"
    | .scripts.lint="eslint test src"
    | .scripts.test="rnx test"
    | .scripts.fake-server=":"
    | .babel.env.specs.presets=["es2015", "react", "stage-0"]
    | .babel.env.specs.retainLines="true"
    | .config.appName="$projectName"    
    | .config.iphoneModel="iPhone 6s" ' package.json > tmp.json && mv tmp.json package.json

npm install react-native-extended-cli enzyme proxyquire react-dom react-native-mock --save-dev