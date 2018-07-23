from selenium import webdriver
from selenium.webdriver.common.keys import Keys
from selenium.common.exceptions import TimeoutException
from selenium.webdriver.support.ui import WebDriverWait
from selenium.webdriver.support import expected_conditions as EC
from selenium.webdriver.common.by import By
from selenium.webdriver.support.ui import Select
import datetime as dt
import time
password="PutPasswordHere"
username="PutUsernameHere"
clientName='PutClientNameHere'


def writeInField(foundfield,input):
   #################################################################
      #find and locate the username field
      #Locate the field by id and then write in needed input
   #################################################################
   search_field = driver.find_element_by_id(foundfield)
   search_field.clear()
   #enter username keyword and submit
   search_field.send_keys(input)

def lookForElement(elementToLookFor):
    #################################################################
       #look for the element and then resume the script if it takes to much time throw an exception.
       #Page for the following code https://stackoverflow.com/questions/26566799/how-to-wait-until-the-page-is-loaded-with-selenium-for-python
       #wait for the reports tab and then click
	#################################################################
	try:
		waitForLinkElement(elementToLookFor)
		print ("Page is ready!")
		driver.find_element_by_link_text(elementToLookFor).click()
	except TimeoutException:
		print ("Time to upgrade your internet")

def waitForLinkElement(elementToLookFor):
	#################################################################
	#	Wait for the element by checking to see if the link text exists	
	#################################################################
		element_present = EC.presence_of_element_located((By.LINK_TEXT, elementToLookFor))
		WebDriverWait(driver, timeout).until(element_present)
    
def waitForCssElement(elementToLookFor):
	#################################################################
	#	Wait for the element by checking to see if the css selector exists	
	#################################################################
		element_present = EC.presence_of_element_located((By.CSS_SELECTOR, elementToLookFor))
		WebDriverWait(driver, timeout).until(element_present)
    
def selectItemInDropdown(dropdownID,itemText):
	#################################################################
		#select the dropdown by fist selecting the menu and then the option
	#################################################################
	select = Select(driver.find_element_by_id(dropdownID))
	select.select_by_visible_text(itemText)

def getdates():
	#################################################################
		#"Get the date and a week previous and pass it back"
	#################################################################
	today = dt.date.today()
	week_ago = today - dt.timedelta(days=7)
	today=today.strftime('%m/%d/%Y')
	week_ago=week_ago.strftime('%m/%d/%Y')
	return today, week_ago

def getTableFile():
	#################################################################
		#Get table file by getting all elements of the report_filter and then serializing it and adding it to the url
		#this should be the final url for the file:https://dashboard.txtwire.com/reporting/inboundMessages?entity_id=3_5700545546&from_date=10%2F30%2F2017+00%3At0%3A00&to_date=11%2F30%2F2017+23%3A59%3A59&report_table_length=100&action=csv
		# Have to make it wait because otherwise it will come with a "not visible" warning	
	#################################################################	
	time.sleep(.5)
	csvImageFile="#export_csv"
	waitForCssElement(csvImageFile)
	element= driver.find_element(By.CSS_SELECTOR, csvImageFile)
	element.click()
	print("Just Clicked")



##################################################################################################################################	
##################################################################################################################################	
	#Execute the functions. Move to a main function in the future

	#####IN ORDER OF EXECUTION#####
	'''
	1)create a new firefox session and wait 10 seconds
	2) Go to txtwire home page
	3) Put in username and password
	4)Go to the reports page and fill it out
	5)Download the file by serializing(In Progress)

	'''
##################################################################################################################################
##################################################################################################################################
### 1 ###
driver = webdriver.Chrome()
driver.implicitly_wait(10)
# driver.maximize_window()
#set the timeout for waiting fo rlink text
timeout= 5
### 2 ###
driver.get("https://dashboard.txtwire.com/")
### 3 ###
writeInField("username",username)
#Should recall from database but for now plain text will work, may also ask for password through input
writeInField("password",password)
driver.find_element_by_id("loginPasswordButton").click()
### 4 ###
lookForElement('Reports')
selectItemInDropdown('report_type','Messages Received')
#formatting seems to be required but try messing with it to see!
selectItemInDropdown('entity_id',clientName)
firstDate, secondDate=getdates()
writeInField("from_date",secondDate)
writeInField("to_date",firstDate)
driver.find_element_by_id("generate_report").click()
### 5 ###
getTableFile()
