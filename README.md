[![Build Status](https://github.com/xavierLowmiller/app-parser/workflows/CI/badge.svg)](https://github.com/xavierLowmiller/app-parser/workflows/CI)
[![Swift 5](https://img.shields.io/badge/Swift-5-orange.svg)](https://swift.org)
![platform](https://img.shields.io/badge/platform-macOS-lightgrey.svg)
![platform](https://img.shields.io/badge/platform-Linux-lightgrey.svg)

# app-parser

Parses metadata from `.apk` and `.ipa` files

```sh
$ app-parser example.ipa
```

## Features

| Android | iOS | Feature                   |
| ------- | --- | ------------------------- |
| ❌      | ✅  | Display Name              |
| ✅      | ✅  | Version                   |
| ✅      | ✅  | Bundle/Package Identifier |
| ✅      | ✅  | OS                        |
| ❌      | ❌  | Minimum OS Version        |
| ❌      | ❌  | Icons                     |

