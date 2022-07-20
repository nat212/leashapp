#!/bin/bash

pushd build/app/intermediates/merged_native_libs/prodRelease/out/lib
zip -r debug-symbols.zip ./arm64-v8a ./armeabi-v7a ./x86_64
popd