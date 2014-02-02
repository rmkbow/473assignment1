#!/bin/bash
#set -x

APP="python xml2json.py"
SEPARATOR="echo -----------------------------"
TEST_FILES="TestData/TestFiles"
OUTPUT_FILES="TestOutput/Files"
EXIT_CODE="echo $?"

VALID_XML="single_element_xml simple_note_xml no_root_simple_note_xml entity_xml entity_xml_2 external_dtd_xml"
#VALID_JSON=""

#FILES=$VALID_XML

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


for XML_FILES in $VALID_XML
do
	for FILEPATH in "$TEST_FILES"/$XML_FILES
	do
		XML=true
		FILE=${FILEPATH##*/}

		if [ -f $TEST_FILES/$FILE ]; then
			FILE_EXISTS=true
			echo "$FILE exists"
		else
			FILE_EXISTS=false
			echo "$FILE does not exist"
		fi

		if $FILE_EXISTS; then
			
			for STRIP_TEXT in "${STRIP_TEXT_LIST[@]}"; do
				for PRETTY in "${PRETTY_LIST[@]}"; do
					for STRIP_NAMESPACE in "${STRIP_NAMESPACE_LIST[@]}"; do
						for STRIP_NEWLINES in "${STRIP_NEWLINES_LIST[@]}"; do
							echo "$STRIP_TEXT $PRETTY $STRIP_NAMESPACE $STRIP_NEWLINES"
							$APP $STRIP_TEXT $PRETTY $STRIP_NAMESPACE $STRIP_NEWLINES $TEST_FILES/$FILE
							checkExitStatus $(echo $?)
							$SEPARATOR
						done
					done
				done
			done



			#Test with only input file specified, no other arguments
			#$APP $TEST_FILES/$FILE
			#checkExitStatus $(echo $?)
			#$SEPARATOR

			#Test with -t xml2json argument and input file
			#$APP $XML2JSON $TEST_FILES/$FILE
			#checkExitStatus $(echo $?)
			#$SEPARATOR			

			#Test with -o argument to specify output file and input file
			#$APP -o $OUTPUT_FILES/$FILE $TEST_FILES/$FILE
			#checkExitStatus $(echo $?)			
			#$SEPARATOR

			#Test with -t, -o, and input file
			#$APP -o $OUTPUT_FILES/$FILE $XML2JSON $TEST_FILES/$FILE
			#checkExitStatus $(echo $?)
			#$SEPARATOR	
			
			#Test with --strip_text
			#$APP $STRIP_TEXT $TEST_FILES/$FILE
			#checkExitStatus $(echo $?)
			#$SEPARATOR	
			
			#Test with --pretty
			#$APP $PRETTY $TEST_FILES/$FILE
			#checkExitStatus $(echo $?)
			#$SEPARATOR
			
			#Test with --strip_namespace
			#$APP $STRIP_NAMESPACE $TEST_FILES/$FILE
			#checkExitStatus $(echo $?)
			#$SEPARATOR	

			#Test with --strip_newlines
			#$APP $STRIP_NEWLINES $TEST_FILES/$FILE
                        #checkExitStatus $(echo $?)
                        #$SEPARATOR 
		fi

	done

done


exit 0



