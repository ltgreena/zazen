.PHONY: build run clean generate

generate:
	xcodegen generate

build: generate
	xcodebuild -project Zazen.xcodeproj -scheme Zazen -configuration Release SYMROOT=$(PWD)/build build

run: build
	open build/Release/Zazen.app

clean:
	rm -rf build DerivedData Zazen.xcodeproj
