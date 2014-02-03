#!/bin/bash
set -x

APP="python xml2json.py"
SEPARATOR="echo -----------------------------"

TEST_FILES="TestData/TestFiles"

EXPECTED_FILES="TestData/ExpectedOutput"
EXPECTED_MESSAGES="TestData/ExpectedMessages"

OUTPUT_FILES="TestOutput/Files"
OUTPUT_MESSAGES="TestOutput/Messages"


VALID_XML="single_element_xml simple_note_xml no_root_simple_note_xml entity_xml entity_xml_2 external_dtd_xml"
VALID_JSON="simple_valid_json single_element_json no_root_json nested_json"
INVALID_XML="invalid_xml"
INVALID_JSON="invalid_json multiple_roots_json"

function checkExitStatus(){
	if [ $1 -eq 0 ]; then
		echo "PASS"
	else
		echo "FAIL"
	fi
}

XML2JSON="-t xml2json"
JSON2XML="-t json2xml"

VALID_FILES="$VALID_XML $VALID_JSON"
STRIP_TEXT_LIST=(' ' '--strip_text')
PRETTY_LIST=(' ' '--pretty')
STRIP_NAMESPACE_LIST=(' ' '--strip_namespace')
STRIP_NEWLINES_LIST=(' ' '--strip_newlines')


for VALID_FILE in $VALID_FILES
do


	for FILEPATH in "$TEST_FILES"/$VALID_FILE
	do
		FILE=${FILEPATH##*/}
		if [ -f $TEST_FILES/$FILE ]; then
			FILE_EXISTS=true
			echo "$FILE exists"
		else
			FILE_EXISTS=false
			echo "$FILE does not exist"
		fi



		if [[ $FILE == *xml* ]]; then
			XML=true
		else
			XML=false
		fi

		if [[ $FILE == *json* ]]; then
			JSON=true
		else
			JSON=false
		fi


		if $XML; then
			TYPE_LIST="$XML2JSON"
		else
			TYPE_LIST="$JSON2XML"
			unset STRIP_TEXT_LIST
			STRIP_TEXT_LIST=" "
			unset PRETTY_LIST
			PRETTY_LIST=" "
			unset STRIP_NAMESPACE_LIST
			STRIP_NAMESPACE_LIST=" "
		fi

		if $FILE_EXISTS; then
			for TYPE in "${TYPE_LIST[@]}"; do
				for STRIP_TEXT in "${STRIP_TEXT_LIST[@]}"; do
					for PRETTY in "${PRETTY_LIST[@]}"; do
						for STRIP_NAMESPACE in "${STRIP_NAMESPACE_LIST[@]}"; do
							for STRIP_NEWLINES in "${STRIP_NEWLINES_LIST[@]}"; do
								echo "$TYPE $STRIP_TEXT $PRETTY $STRIP_NAMESPACE $STRIP_NEWLINES"
								$APP $TYPE $STRIP_TEXT $PRETTY $STRIP_NAMESPACE $STRIP_NEWLINES -o "$OUTPUT_FILES/$FILE$TYPE$STRIP_TEXT$PRETTY$STRIP_NAMESPACE$STRIP_NEWLINES" $TEST_FILES/$FILE
								EXIT_CODE=$(echo $?)
								checkExitStatus $(echo $EXIT_CODE) > "$OUTPUT_MESSAGES/$FILE$TYPE$STRIP_TEXT$PRETTY$STRIP_NAMESPACE$STRIP_NEWLINES"
								if [[ $EXIT_CODE -eq 1 ]]; then
									echo "" > "$OUTPUT_FILES/$FILE$TYPE$STRIP_TEXT$PRETTY$STRIP_NAMESPACE$STRIP_NEWLINES"

								fi
								diff  "$OUTPUT_FILES/$FILE$TYPE$STRIP_TEXT$PRETTY$STRIP_NAMESPACE$STRIP_NEWLINES"  "$EXPECTED_FILES/$FILE$TYPE$STRIP_TEXT$PRETTY$STRIP_NAMESPACE$STRIP_NEWLINES"
								$SEPARATOR
							done
						done
					done
				done
			done
		fi

	done

done


exit 0



