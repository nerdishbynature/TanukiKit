install:
	brew update || brew update
	brew install carthage
	brew install python
	pip install codecov
	carthage bootstrap

test:
	set -o pipefail && xcodebuild clean test -scheme TanukiKit -sdk iphonesimulator ONLY_ACTIVE_ARCH=YES -enableCodeCoverage YES | xcpretty -c

post_coverage:
	bundle exec slather coverage --input-format profdata -x --ignore "../**/*/Xcode*" --ignore "Carthage/**" --output-directory slather-report --scheme TanukiKit TanukiKit.xcodeproj
	codecov -f slather-report/cobertura.xml
