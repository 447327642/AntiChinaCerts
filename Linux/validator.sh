#!/bin/sh
# This script accesses the test sites described in README.
# This file should be updated according to README file.

SOURCE_DIR=$(dirname "$0")

base() {
    "$SOURCE_DIR/../Mac/test/test-url.sh" \
      https://211.146.10.133/ \
      https://wacc.n.shifen.com/
}

extended() {
    "$SOURCE_DIR/../Mac/test/test-url.sh" \
      https://cstest.cfca.com.cn/ \
      https://cs.cfca.com.cn/ \
      https://www.sheca.com/ \
      https://ibanks.bankofshanghai.com/ \
      https://www.gdca.com.cn/ \
      https://root1evtest.wosign.com/ \
      https://root2evtest.wosign.com/ \
      https://root4evtest.wosign.com/ \
      https://root5evtest.wosign.com/
}

all() {
    "$SOURCE_DIR/../Mac/test/test-url.sh" \
      https://kyfw.12306.cn/ \
      https://www.nic.edu.cn/ \
      https://www.hongkongpost.hk/ \
      https://epki.com.tw/ \
      https://www.twca.com.tw/ \
      https://www.startcom.org/
}

echo "---------------------"
echo "Beginning base tests."
echo "---------------------"
base
echo "-------------------------"
echo "Beginning extended tests."
echo "-------------------------"
extended
echo "--------------------"
echo "Beginning all tests."
echo "--------------------"
all
echo "-------------------"
echo "All tests executed."
