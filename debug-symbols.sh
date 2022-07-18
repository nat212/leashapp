#!/bin/bash

pushd build/app/intermediates/merged_native_libs/release/out/lib
zip -r debug-symbols.zip ./arm64-v8a ./armeabi-v7a ./x86_64
popd
mv build/app/intermediates/merged_native_libs/release/out/lib/debug-symbols.zip .