# IDWCH2.0
I don't want to correct homework, version 2.

# Introduction
Designed for TAs, <ins>**IDWCH2.0**</ins> is a nearly fully automated example, demonstrating utilizing a few scripts to grade a large volume of assignments quickly.

It contains three features:
1. Download the assignment zip files from a specific link.
2. Correct homework using pre-established test cases and calculate scores.
3. Fill scores into a Google Sheet.

# Usage
Download the whole project, modify some files, and simply run the Python script.
```
python3 activate.py
```

It will do all things as follows.
|Feature|Procedure|Execution location|
|:------|:--------|:-----------------|
|1|Find the specific element containing the target and wait for the download to complete|`activate.py`|
|2-1|Unzip the target, create folders, and organize files|`Corrector/start.sh`|
|2-2|Compare the execution results with the correct answers and output `score.txt`|`Corrector/correct.sh`|
|3|Open the URL with Google Sheets API and fill scores into it|`activate.py`|

# Note
Before starting, you have to do & know several things:
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

- As for the chromedriver, you can get the latest version here: https://googlechromelabs.github.io/chrome-for-testing/

# Demo
Testing environment:
- Ubuntu 20.04.5 LTS
- Python 3.8.10
  - Selenium 4.16.0
  - Pandas 2.0.3
  - Pygsheets 2.0.6
- Google Chrome 120.0.6099.199 (Official Build) (64-bit)
- Chromedriver 120.0.6099.109 (r1217362), Stable, linux64

<a href="https://youtu.be/EIV3oNEiH4I" target="_blank">https://youtu.be/EIV3oNEiH4I</a>

In our demonstration, we obtained a zip file from NYCU E3 platform, specifically from the Data Structure course. The task at hand involves correcting an assignment where participants are required to submit their C/C++ files. The objective is to read input from a file named `input.txt` within the same directory and generate the output into a file named `answer.txt`, also located in the same directory.

To initiate the correction process, we execute the Corrector/start.sh script. This script creates temporary folders to store code, followed by the execution of Corrector/correct.sh in a new terminal. This script takes `Testcase/input{i}.txt` as `input.txt` and compares the resulting output with `Testcase/answer{i}.txt`. Ultimately, this process yields a score for each student. Ultimately, this process yields a score for each student.

Upon completion, we proceed to select our desired column 'G', identify the specific row corresponding to the student ID, and input the obtained score. This concludes the correction process.

# Q&A
Q: Why does my `driver.find_element()` always go wrong?\
A: First, you can try to lengthen the interval of `time.sleep()`. Otherwise, you're probably setting the wrong XPath.
