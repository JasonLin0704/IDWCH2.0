import time
from collections import defaultdict
from selenium import webdriver
from selenium.webdriver.common.by import By
from selenium.webdriver.common.keys import Keys
import pandas as pd
import pygsheets
import os
import json


def click_element_by_XPATH(driver, xpath, wait_time=2):
    driver.find_element(By.XPATH, xpath).click()
    time.sleep(max(wait_time, 0))


def download_from_urls():
    with open(os.path.join('Credential', 'credential.json'), 'r') as file:
        data = json.load(file)

    # Activate chrome webdriver
    driver = webdriver.Chrome()
    driver.get('https://portal.nycu.edu.tw/#/login')
    time.sleep(3)

    driver.find_element(By.XPATH,"//input[@id='account']").send_keys(data['NYCU']['account'])
    driver.find_element(By.XPATH,"//input[@id='password']").send_keys(data['NYCU']['password'])
    time.sleep(1)
    driver.find_element(By.XPATH,"//input[@id='account']").send_keys(Keys.ENTER)
    time.sleep(3)

    ### You may need to pass NYCU two-factor authentication once before you run this script.
    ### Otherwise, you will fail here.   

    click_element_by_XPATH(driver, "//div[@class='hamburger-container']/child::*")
    click_element_by_XPATH(driver, "(//span[text()='陽明交通大學 NYCU Campus'])[1]/parent::*/parent::*")
    click_element_by_XPATH(driver, "(//a[@title='E3數位教學平台'])[1]", wait_time=5)

    # Switch to another tab
    driver.switch_to.window(driver.window_handles[-1])
    click_element_by_XPATH(driver, "//a[@class='dropdown-toggle']")
    click_element_by_XPATH(driver, "//a[contains(text(), '歷年課程')]")
    click_element_by_XPATH(driver, "//a[contains(text(), '資料結構')]")
    click_element_by_XPATH(driver, "//span[text()='HW3']/parent::*")
    click_element_by_XPATH(driver, "(//a[contains(text(), '檢視所有繳交的作業')])[2]")
    click_element_by_XPATH(driver, "//select[@class='custom-select urlselect']")
    click_element_by_XPATH(driver, "//option[contains(text(), '下載全部繳交的作業')]")

    # Wait for download to complete
    download_destination = '/home/jason/Downloads'
    while any([filename.endswith(".crdownload") for filename in os.listdir(download_destination)]):
        time.sleep(2)


def fill_in_gsheet():
    with open(os.path.join('Credential', 'credential.json')) as f:
        data = json.load(f)
    
    # Read key
    gc = pygsheets.authorize(service_file=os.path.join('Credential', data['gsheet']['key_filename']))

    # Open gsheeet with key
    sht = gc.open_by_url(data['gsheet']['url'])

    # Read data from .txt file and fill them in the worksheet
    wks = sht[0]
    student_id, score = [], []
    file_name = 'score.txt'
    with open(file_name, 'r') as file:
        for line in file:
            student_id.append(line.split()[0].split('.')[0].split('_')[2])
            score.append(line.split()[1].strip())

    for i in range(len(student_id)):
        col = 'G'
        row = str(wks.find(student_id[i])[0].row)
        wks.cell(col + row).set_value(score[i])
        print(f"ID: {student_id[i]}, score: {score[i]}, done")


if __name__ == '__main__':
    download_from_urls()
    os.system('./Corrector/start.sh')
    fill_in_gsheet()
