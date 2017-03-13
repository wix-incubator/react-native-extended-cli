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
    | .private=false
    | .scripts.build="rnx build"
    | .scripts.release="rnx release"
    | .scripts.lint="rnx lint"
    | .scripts.test="rnx test"
    | .scripts.fake-server=":"
    | .babel.env.specs.presets=["es2015", "react", "stage-0"]
    | .babel.env.specs.retainLines="true"
    | .config.appName="'${projectName}'"
    | .config.iphoneModel="iPhone 7"
    | .config.packageName="com.org.'${projectName}'"
    | .detox.session.server="ws://localhost:8099"
    | .detox.session.sessionId="'${projectName}'"
    | .detox."ios-simulator".app="ios/DerivedData/'${projectName}'/Build/Products/Debug-iphonesimulator/'${projectName}'.app"
    | .detox."ios-simulator".device="iPhone 7, iOS 10.1" ' package.json > tmp.json && mv tmp.json package.json

npm i --save-dev \
  react-native-extended-cli \
  proxyquire \
  react-dom \
  enzyme enzyme-drivers \
  mocha jasmine jasmine-spec-reporter \
  react-addons-test-utils \
  detox detox-server \
  jasmine-reporters \
  jasmine-spec-reporter \
  eslint \
  eslint-config-wix \
  eslint-plugin-react-native \
  react-native-mock

echo "Please enter XCode and change your package name to com.org.$projectName (or just change packageName in package.json)"