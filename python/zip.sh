#!/bin/bash

if [ -e lambda_function.zip ]; then
  rm lambda_function.zip
fi

cd /usr/local/lib/python3.11/site-packages
zip -r9 /project/lambda_function.zip .
cd /usr/local/lib64/python3.11/site-packages
zip -r9 /project/lambda_function.zip .

cd /project/python
zip -g /project/lambda_function.zip lambda_function.py
