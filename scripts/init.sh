projectName=$1
rnVersion=$2

if [ "$rnVersion" == "" ]; then
    rnVersion="latest"
fi

echo Initializing React Native project $projectName with version: $rnVersion

rninit init $projectName --source react-native@$rnVersion

echo Copying project template from $rnxRoot/template/ to ./

cd $projectName
cp -r $rnxRoot/template/ ./
mv .npmignore.template .npmignore

echo Setting up package.json

jq -r '.version="1.0.0"
    | .main="src/module.js"
    | .private=false
    | .scripts.start="rnx start"
    | .scripts.build="rnx build"
    | .scripts.release="rnx release"
    | .scripts.lint="rnx lint"
    | .scripts.test="rnx test"
    | .scripts."fake-server"=":"
    | .babel.env.specs.presets=["react-native"]
    | .babel.env.specs.retainLines="true"
    | .rnx.appName="'${projectName}'"
    | .rnx.iphoneModel="iPhone 6s"
    | .rnx.packageName="com.org.'${projectName}'"
    | .detox.specs="test/e2e"
    | .detox.configurations."ios.sim.debug".binaryPath="ios/DerivedData/'${projectName}'/Build/Products/Debug-iphonesimulator/'${projectName}'.app"
    | .detox.configurations."ios.sim.debug".type="ios.simulator"
    | .detox.configurations."ios.sim.debug".name="iPhone 6s"
    | .detox.configurations."ios.sim.release".binaryPath="ios/DerivedData/'${projectName}'/Build/Products/Release-iphonesimulator/'${projectName}'.app"
    | .detox.configurations."ios.sim.release".type="ios.simulator"
    | .detox.configurations."ios.sim.release".name="iPhone 6s"
    ' package.json > tmp.json && mv tmp.json package.json

echo Adding dev dependencies

yarn add -D \
  react-native-extended-cli \
  proxyquire \
  react-dom \
  enzyme enzyme-drivers \
  mocha jasmine jasmine-spec-reporter \
  react-addons-test-utils \
  detox detox-server \
  jasmine-reporters \
  eslint \
  eslint-config-wix \
  eslint-plugin-react-native \
  eslint-plugin-import \
  react-native-mock \
  react-native-navigation

echo "Please enter XCode and change your package name to com.$org.$projectName (or just change packageName in package.json)"
echo "If you want to publish this module to a private registry, add publishConfig.registry to your package.json as well."
echo "You also need to set up React Native Navigation on your own. Sorry."
