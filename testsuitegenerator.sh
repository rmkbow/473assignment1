#!/bin/bash



set -x







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



			$APP $TEST_FILES/$FILE



			checkExitStatus $(echo $?)



			$SEPARATOR



			$APP -t xml2json $TEST_FILES/$FILE

			checkExitStatus $(echo $?)

			

			$SEPARATOR			



			# $APP $FILE > $OUTPUT_FILES/$FILE



			

			# $APP -o $OUTPUT_FILES/$FILE $TEST_FILES/$FILE



			# $SEPARATOR	



			# $APP -t xml2json -o $OUTPUT_FILES/$FILE $FILE



			# $SEPARATOR	



			# $APP --strip_text $TEST_FILES/$FILE



			# $SEPARATOR	



			# $APP --pretty $TEST_FILES/$FILE



			# $APP --strip_namespace $TEST_FILES/$FILE



			# $SEPARATOR	



			# $APP --strip_newlines $TEST_FILES/$FILE



		fi



	done



done







exit 0



