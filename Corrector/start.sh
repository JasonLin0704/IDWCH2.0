#!/bin/bash

### You need to change:
# ---------------------------------------------------------------------------------
ZIP_FILE="/home/jason/Downloads/*HW3*.zip"  # The exact zip file downloaded from E3
# ---------------------------------------------------------------------------------


### Some path variables (you don't need to change)
PROJECT_DIR=$(pwd)
CORRECTOR_DIR="${PROJECT_DIR}/Corrector"
TESTCASE_DIR="${CORRECTOR_DIR}/Testcase"
HW_DIR="${PROJECT_DIR}/HW"
TARGET_DIR="${HW_DIR}/Target"
C_DIR="${HW_DIR}/3_c"
CPP_DIR="${HW_DIR}/3_cpp"
PDF_DIR="${HW_DIR}/3_pdf"


### Create processing folders and unzip
if [ -d ${HW_DIR} ]; then rm -r ${HW_DIR}; fi
if [ -d ${TARGET_DIR} ]; then rm -r ${HW_DIR}; fi
mkdir ${HW_DIR} ${TARGET_DIR}
cp $ZIP_FILE ${HW_DIR}
unzip ${HW_DIR}/*.zip -d ${TARGET_DIR}
rm ${HW_DIR}/*.zip


### Replace spaces with '_' for each file name
for oldname in ${TARGET_DIR}/*; do
    newname=`echo $oldname | sed -e 's/ /_/g'`
    mv "$oldname" "$newname"
done


### Classify the files into certain folders
mkdir -p ${C_DIR} ${CPP_DIR} ${PDF_DIR}
for file in ${TARGET_DIR}/*/*; do
    if [ ${file##*.} == "c" ]; then mv ${file} ${C_DIR}; fi
    if [ ${file##*.} == "cpp" ]; then mv ${file} ${CPP_DIR}; fi
    if [ ${file##*.} == "pdf" ]; then mv ${file} ${PDF_DIR}; fi
done


### Start correcting
chmod +x ${CORRECTOR_DIR}/correct.sh
if [ -f "${PROJECT_DIR}/score.txt" ]; then rm "${PROJECT_DIR}/score.txt"; fi

# Execute ${CORRECTOR_DIR}/correct.sh in a new shell
( cd ${C_DIR} && ${CORRECTOR_DIR}/correct.sh ${CORRECTOR_DIR} ${TESTCASE_DIR} )
if [ -f "${CORRECTOR_DIR}/score.txt" ]; then
    cat ${CORRECTOR_DIR}/score.txt >> ${PROJECT_DIR}/score.txt 
    rm "${CORRECTOR_DIR}/score.txt";
fi

# Execute ${CORRECTOR_DIR}/correct.sh in a new shell
( cd ${CPP_DIR} && ${CORRECTOR_DIR}/correct.sh ${CORRECTOR_DIR} ${TESTCASE_DIR} )
if [ -f "${CORRECTOR_DIR}/score.txt" ]; then
    cat ${CORRECTOR_DIR}/score.txt >> ${PROJECT_DIR}/score.txt 
    rm "${CORRECTOR_DIR}/score.txt";
fi


### Sort by the student ID
sort ${PROJECT_DIR}/score.txt > ${PROJECT_DIR}/sorted_score.txt
mv ${PROJECT_DIR}/sorted_score.txt ${PROJECT_DIR}/score.txt