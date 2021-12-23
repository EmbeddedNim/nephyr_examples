
import ../src/zephyr/wrappers/wrapper_utils

import macros

{.emit: """
#define SOME_TEST_STR(n) #n 
#define Img0 1133
#define Img1 2266
#define DEVICE_DECLARE(a, b) int AAA = (a); int BBB = (b); 
#define DEVICE_NAME_ID(n) n
#define DEVICE_NAME_GET(n) n
#define SOME_TEST_INT(n, n2) n + n2
""".}

# test
const
  val_some = BIT(4)
  val_high = BIT(32)

echo "val_some: ", $val_some
echo "val_high: ", $val_high

# var testProc {.importc: "testProc(my_label)", nodecl.}: int 

proc testSomeInvoke() =
    CDeclartionInvoke(DEVICE_DECLARE, Img0, Img1)
    echo "done"

testSomeInvoke()

CDeclartionInvoke(DEVICE_DECLARE, Img0, Img1)
CDefineExpression(device_img_void, DEVICE_NAME_SET(Img0, null)): int

CDefineExpression(DEVICE_NAME_ID, DEVICE_NAME_ID(Id)): int

proc someTestInt(tk: cminvtoken, n: int): int {.importc: "SOME_TEST_INT", nodecl.}
proc someTestStr(tk: cminvtoken): cstring {.importc: "SOME_TEST_STR", nodecl.}

echo "MyToken2: someTestStr: `", someTestStr(tok"Img0"),  "` end"
echo "MyToken2: someTestStr: `", someTestStr(tok`Img0`),  "` end"

# echo "MyToken2: someTestStr: `", someTestStr(tok Img0),  "` end"

echo "MyToken11: someTestInt: `", someTestInt(CTOKEN(Img0), 3),  "` end"
echo "MyToken21: someTestStr: `", someTestStr(CTOKEN(Img0)),  "` end"

# invalid:
# echo "MyToken4: someTestStr: `", someTestStr(),  "` end"

expandMacros:
  CDefineExpression(device_img0, DEVICE_NAME_GET(Img0)): int
  CDefineDeclareVar(device_img1, DEVICE_NAME_ID(Img1)): int
  CDefineDeclareVar(device_img2, DEVICE_NAME_ID(1 + 1)): int

echo "device_img0: ", $device_img0
echo "device_img1: ", $(device_img1)
echo "device_img2: ", $(device_img2)

assert device_img0 == 1133
assert device_img1 == 2266
assert device_img2 == 2

# dumpAstGen:
  # var myVar {.importc: "DEFMAC(a)", nodecl.}: uint
