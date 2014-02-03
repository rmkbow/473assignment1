#!/bin/bash
#set -x

APP="python xml2json.py"
SEPARATOR="echo -----------------------------"
TEST_FILES="TestData/TestFiles"
OUTPUT_FILES="TestOutput/Files"
EXIT_CODE="echo $?"

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
STRIP_TEXT_LIST=(' ' '--strip_text')
PRETTY_LIST=(' ' '--pretty')
STRIP_NAMESPACE_LIST=(' ' '--strip_namespace')
STRIP_NEWLINES_LIST=(' ' '--strip_newlines')


VALID_FILES="$VALID_XML $VALID_JSON"

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
			TYPE=$XML2JSON
		elif $JSON; then
			TYPE=$JSON2XML
		fi


		if $FILE_EXISTS; then	
			for STRIP_TEXT in "${STRIP_TEXT_LIST[@]}"; do
				for PRETTY in "${PRETTY_LIST[@]}"; do
					for STRIP_NAMESPACE in "${STRIP_NAMESPACE_LIST[@]}"; do
						for STRIP_NEWLINES in "${STRIP_NEWLINES_LIST[@]}"; do
							echo "$TYPE $STRIP_TEXT $PRETTY $STRIP_NAMESPACE $STRIP_NEWLINES"
							$APP $TYPE $STRIP_TEXT $PRETTY $STRIP_NAMESPACE $STRIP_NEWLINES $TEST_FILES/$FILE
							checkExitStatus $(echo $?)
							$SEPARATOR
						done
					done
				done
			done

		fi

	done

done


exit 0



