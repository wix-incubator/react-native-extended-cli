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
    | .scripts.lint="rnx lint"
    | .scripts.test="rnx test"
    | .scripts.fakeserver=":"
    | .babel.env.specs.presets=["es2015", "react", "stage-0"]
    | .babel.env.specs.retainLines="true"
    | .config.packageName="com.org.$projectName"
    | .config.appName="$projectName"    
    | .config.iphoneModel="iPhone 6s" ' package.json > tmp.json && mv tmp.json package.json

npm install react-native-extended-cli enzyme proxyquire react-dom enzyme-drivers detox detox-server jasmine-reporters jasmine-spec-reporter eslint eslint-config-wix jasmine eslint-plugin-react-native react-native-mock --save-dev