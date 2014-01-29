#!/bin/bash
set -x

APP="python xml2json.py"

TEST_FILES="TestData/TestFiles"
OUTPUT_FILES="TestOutput/Files"


for FILEPATH in "$TEST_FILES"/*
do
	FILE=$(basename $FILEPATH)

	$APP $TEST_FILES/$FILE

	$APP -t xml2json $TEST_FILES/$FILE

	$APP $FILE > $OUTPUT_FILES/$FILE

	$APP -o $OUTPUT_FILES/$FILENAME $TEST_FILES/$FILE

	$APP -t xml2json -o $OUTPUT_FILES/$FILE $FILE

	$APP --strip_text $TEST_FILES/$FILE

	$APP --pretty $TEST_FILES/$FILE

	$APP --strip_namespace $TEST_FILES/$FILE

	$APP --strip_newlines $TEST_FILES/$FILE

done


exit 0
