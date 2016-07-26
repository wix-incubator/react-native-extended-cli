echo Initialling React Native project $1 with version $2

echo Running: rninit init $1 --source react-native@$2

rninit init $1 --source react-native@$2

exit

mkdir src
mkdir test
mkdir test/e2e
mkdir test/spec

touch demo-app.component.js
touch src/module.js