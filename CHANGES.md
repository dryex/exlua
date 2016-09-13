# Change Log
All notable changes to this project will be documented in this file.
This project adheres to [Semantic Versioning](http://semver.org/).

## [HEAD] - Unreleased
### Added
- Added `Lua.Thread`.
- Added `Lua.encode/1`, `Lua.encode/2`, `Lua.decode/1`.
- Added `Lua.exec!/2`, `Lua.exec_file!/2`.
- Added `Lua.require!/2`.
- Added `Lua.set_global/3`, `Lua.get_global/2`.
- Added `Lua.set_package_path/2`.

## [0.3.0] - 2016-08-08
### Added
- Added `Lua.get_table/2`.

## [0.2.0] - 2016-08-05
### Added
- Added `Lua.call_chunk!/3`, `Lua.call_function!/3`.
- Added `Lua.gc/1`.
- Added `Lua.load/2`, `Lua.load!/2`, `Lua.load_file/2`, `Lua.load_file!/2`.
- Added `Lua.set_table/3`.
- Added `Lua.State.wrap/1`, `Lua.State.unwrap/1`.

## 0.1.0 - 2016-08-04
### Added
- Initial release implementing `Lua.{eval,eval!,eval_file,eval_file!}/2`.

[HEAD]:  https://github.com/bendiken/exlua/compare/0.3.0...HEAD
[0.4.0]: https://github.com/bendiken/exlua/compare/0.3.0...0.4.0
[0.3.0]: https://github.com/bendiken/exlua/compare/0.2.0...0.3.0
[0.2.0]: https://github.com/bendiken/exlua/compare/0.1.0...0.2.0
