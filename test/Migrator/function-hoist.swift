// REQUIRES: objc_interop
// RUN: rm -rf %t.mod && mkdir -p %t.mod
// RUN: %target-swift-frontend -emit-module -o %t.mod/cities.swiftmodule %S/Inputs/cities.swift -module-name Cities -parse-as-library
// RUN: rm -rf %t && mkdir -p %t && %target-swift-frontend -c -update-code -disable-migrator-fixits -I %t.mod -primary-file %s -api-diff-data-file %S/API-function-hoist.json -emit-migrated-file-path %t/function-hoist.swift.result -emit-remap-file-path %t/function-hoist.swift.remap -o /dev/null
// RUN: diff -u %S/function-hoist.swift.expected %t/function-hoist.swift.result

import Cities

func getCities() -> [Cities] { return [] }

func foo(_ c : Cities) {
  setCityProperty1(c, 1)
  setCityProperty1(getCities()[0], 1)
  globalCityFunc()
  setCityProperty2(c, 1+1+1, 2+2)
  setCityProperty2(getCities()[0], 1+1+1, 2+2)
  globalCityFunc2(c)
  globalCityFunc2(getCities()[0])
  _ = globalCityFunc3(c, 1) + 2
  _ = globalCityFunc4(c, 1, 2) + 2
  _ = globalCityFunc5() + 2 + 1
}
