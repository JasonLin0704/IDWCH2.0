# IDWCH2.0
I don't want to correct homework, version 2.

# Introduction
Designed for TAs, <ins>**IDWCH2.0**</ins> is a nearly fully automated example, demonstrating utilizing a few scripts to grade a large volume of assignments quickly.

It contains three features:
1. Download the assignment zip files from a specific link.
2. Correct homework using pre-established test cases and Calculate scores.
3. Fill scores into a Google Sheet.

# How to use it?
|Feature|Procedure|Execution|
|:------|:--------|:--------|
|1|Find the specific element containing the target and wait for the download to complete|`activate.py`|
|2-1|Unzip the target, create folders, and organize files|`Corrector/start.sh`|
|2-2|Compare the execution results with the correct answers and output `score.txt`|`Corrector/correct.sh`|
|3|Open the URL with Google Sheets API and fill scores into it|`activate.py`|

### Before starting, you have to do & know several things:
- Please modify the function `download_from_urls()` in `activate.py` to direct to your desired URL.
- Please modify `Credential/credential.json`.
  - The default 'NYCU' is my information for login.
  - The default 'gsheet' is my information for Google Sheets API.
    - The default 'key_filename' is the name of the JSON file, which is the key to use API.
    - The default 'url' is the URL of the Google Sheet.
- Please modify `Corrector/start.sh` and `Corrector/correct.sh` depending on your needs.

- To use Google Sheets API, you should:
  - Enable the Google Sheets API in "Google Cloud Platform."
  - Create a service account and a new key. The name of the key would be like `isentropic-keep-xxxxxx-xxxxxxxxxxxx.json`.
  - Share your sheet with your service account.
- You can put your `isentropic-keep-xxxxxx-xxxxxxxxxxxx.json` under `Credential`.
- You can put your custom test cases under `Testcase`.

- You may have noticed that I used the term "nearly fully automated," and the reason is that, if the target website for file download has a captcha or two-factor authentication, manual input is required. You can either go through it once in advance to bypass the verification (NYCU Portal is an example) or set a longer `time.sleep()` to allow for a manual input window.

# Demo
<a href="https://youtu.be/EIV3oNEiH4I" target="_blank">https://youtu.be/EIV3oNEiH4I</a>

In our demo, we downloaded the zip file from NYCU E3 platform. The assignment we want to correct is one of the questions in the Data Structure course. In this example, the course participants would need to provide their c/cpp files, and their goals are to read the input called `input.txt` in the same directory and output the answer to the output file called `answer.txt`, also in the same directory. To correct their homework, we start from `Corrector/start.sh`. We create folders to store codes temporarily, execute `Corrector/correct.sh` by a new terminal, which takes `Testcase/input{i}.txt` as `input.txt` and compare the result with `Testcase/answer{i}.txt`, and finally get the score of each student. In the end, we locate the specific row by finding the student ID and fill the score in. We're done!

# Q&A
Q: Why does my `driver.find_element()` always go wrong?\
A: First, you can try to lengthen the interval of `time.sleep()`. Otherwise, you're probably setting the wrong XPath.
