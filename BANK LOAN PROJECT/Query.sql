SELECT * FROM BankLoanData


						/* DASHBOARD 1 : SUMMARY */


-- Total Loan Applications:


SELECT COUNT(id) AS ToltalLoanApplications FROM BankLoanData

SELECT COUNT(id) AS MTD_ToltalLoanApplications FROM BankLoanData
WHERE MONTH(issue_date) = 12 AND YEAR(issue_date) = 2021

SELECT COUNT(id) AS PMTD_ToltalLoanApplications FROM BankLoanData
WHERE MONTH(issue_date) = 11 AND YEAR(issue_date) = 2021

--(MTD - PMTD) / PMTD



--Total Funded Amount:


SELECT SUM(loan_amount) AS ToltalFundedAmount FROM BankLoanData

SELECT SUM(loan_amount) AS MTD_ToltalFundedAmount FROM BankLoanData
WHERE MONTH(issue_date) = 12 AND YEAR(issue_date) = 2021;

SELECT SUM(loan_amount) AS PMTD_ToltalFundedAmount FROM BankLoanData
WHERE MONTH(issue_date) = 11 AND YEAR(issue_date) = 2021


-- Total Amount Received: 


SELECT SUM(total_payment) AS ToltalReceivedAmount FROM BankLoanData

SELECT SUM(total_payment) AS MTD_ToltalReceivedAmount FROM BankLoanData
WHERE MONTH(issue_date) = 12 AND YEAR(issue_date) = 2021

SELECT SUM(total_payment) AS MTD_ToltalReceivedAmount FROM BankLoanData
WHERE MONTH(issue_date) = 11 AND YEAR(issue_date) = 2021


-- Average Interest Rate: 


SELECT AVG(int_rate) AS AvgInterestRate FROM BankLoanData

SELECT AVG(int_rate) AS MTD_AvgInterestRate FROM BankLoanData
WHERE MONTH(issue_date) = 12 AND YEAR(issue_date) = 2021

SELECT AVG(int_rate) AS PMTD_AvgInterestRate FROM BankLoanData
WHERE MONTH(issue_date) = 11 AND YEAR(issue_date) = 2021


-- Average Debt-to-Income Ratio (DTI):


SELECT ROUND(AVG(dti),4)*100 AS DTI_ratio FROM BankLoanData

SELECT ROUND(AVG(dti),4)*100 AS MTD_DTI_ratio FROM BankLoanData
WHERE MONTH(issue_date) = 12 AND YEAR(issue_date) = 2021

SELECT ROUND(AVG(dti),4)*100 AS PMTD_DTI_ratio FROM BankLoanData
WHERE MONTH(issue_date) = 11 AND YEAR(issue_date) = 2021


SELECT DISTINCT loan_status FROM BankLoanData

-- Good Loan Application Percentage:

SELECT 
	COUNT( CASE WHEN loan_status IN ('Fully Paid' , 'Current') THEN id END) * 100.0 / 
	COUNT(id) AS GoodLoanPercentage
	FROM BankLoanData

-- Good Loan Applications:

SELECT COUNT(id) AS GoodLoanApplications FROM BankLoanData
WHERE loan_status =  'Fully Paid' OR loan_status =  'Current'

-- Good Loan Funded Amount:

SELECT SUM(loan_amount) AS GoodLoanFundedAmount FROM BankLoanData
WHERE loan_status =  'Fully Paid' OR loan_status =  'Current'

--Good Loan Total Received Amount: 

SELECT SUM(total_payment) AS GoodLoanReceivedAmount FROM BankLoanData
WHERE loan_status =  'Fully Paid' OR loan_status =  'Current'

--Bad Loan Application Percentage: 

SELECT
	COUNT( CASE WHEN loan_status = 'Charged Off' THEN id END) * 100.0 /
	COUNT(id) AS BadLoanApplicationPercentage 
	FROM BankLoanData

--Bad Loan Applications: 

SELECT COUNT(id) AS BadLoanApplications FROM BankLoanData
WHERE loan_status = 'Charged Off'

--Bad Loan Funded Amount: 

SELECT SUM(loan_amount) AS BadLoanFundedamount FROM BankLoanData
WHERE loan_status = 'Charged Off'

-- Bad Loan Total Received Amount:

SELECT SUM(total_payment) AS BadLoanReceivedamount FROM BankLoanData
WHERE loan_status = 'Charged Off'


-- loan status
/* 
 'Total Loan Applications,'
 'Total Funded Amount,'
 'Total Amount Received,' 
 'Average Interest Rate,' 
 'Average Debt-to-Income Ratio (DTI),'
*/


SELECT loan_status ,
	COUNT(id) AS TotalLoanApplications ,
	SUM(loan_amount) AS TotalFundedAmount,
	SUM(total_payment) AS TotalAmountReceived,
	ROUND (AVG(int_rate),4)*100 AS AverageInterestRate,
	ROUND(AVG(dti),4)*100 AS AverageDTIratio
	FROM BankLoanData
	GROUP BY loan_status

/*
'Month-to-Date (MTD) Funded Amount,'
'MTD Amount Received,'
 */

SELECT loan_status ,
	SUM(loan_amount) AS MTD_TotalFundedAmount,
	SUM(total_payment) AS MTD_TotalAmountReceived
	FROM BankLoanData
	WHERE MONTH(issue_date) = 12 AND YEAR(issue_date) = 2021
	GROUP BY loan_status

						/* DASHBOARD 2 : OVER VIEW */

-- Monthly Trends by Issue Date

/*
This line chart will showcase how 
'Total Loan Applications,' 
'Total Funded Amount,' 
'Total Amount Received' 
vary over time, allowing us to identify seasonality and long-term trends in lending activities.
*/

SELECT 
	DATENAME(MONTH, issue_date) AS MonthName,
	COUNT(id) AS TotalLoanApplications ,
	SUM(loan_amount) AS TotalFundedAmount,
	SUM(total_payment) AS TotalAmountReceived
	FROM BankLoanData
	GROUP BY MONTH(issue_date), DATENAME(MONTH, issue_date)
	ORDER BY MONTH(issue_date)

--  Regional Analysis by State

/*
This filled map will visually 
represent lending metrics 
categorized by state, 
enabling us to identify regions 
with significant lending activity 
and assess regional disparities.
*/

SELECT 
	address_state AS AddressState,
	COUNT(id) AS TotalLoanApplications ,
	SUM(loan_amount) AS TotalFundedAmount,
	SUM(total_payment) AS TotalAmountReceived
	FROM BankLoanData
	GROUP BY address_state
	ORDER BY address_state

--  Loan Term Analysis

/*
This donut chart will depict loan statistics 
based on different loan terms, 
allowing us to understand the distribution of loans 
across various term lengths.
*/

SELECT 
	term AS LoanTerm,
	COUNT(id) AS TotalLoanApplications ,
	SUM(loan_amount) AS TotalFundedAmount,
	SUM(total_payment) AS TotalAmountReceived
	FROM BankLoanData
	GROUP BY term
	ORDER BY term

-- Employee Length Analysis 

/*
 This bar chart will illustrate 
 how lending metrics are distributed among 
 borrowers with different employment lengths, 
 helping us assess the impact of 
 employment history on loan applications.
*/


SELECT 
	emp_length AS EmploymentLength,
	COUNT(id) AS TotalLoanApplications ,
	SUM(loan_amount) AS TotalFundedAmount,
	SUM(total_payment) AS TotalAmountReceived
	FROM BankLoanData
	GROUP BY emp_length
	ORDER BY emp_length

-- Loan Purpose Breakdown 

/*
This bar chart will provide 
a visual breakdown of loan metrics 
based on the stated purposes of loans, 
aiding in the understanding of 
the primary reasons borrowers seek financing.
*/

SELECT 
	purpose AS PurposeOfLOan,
	COUNT(id) AS TotalLoanApplications ,
	SUM(loan_amount) AS TotalFundedAmount,
	SUM(total_payment) AS TotalAmountReceived
	FROM BankLoanData
	GROUP BY purpose
	ORDER BY purpose

--  Home Ownership Analysis

/*
This tree map will display loan metrics 
categorized by different home ownership statuses, 
allowing for a hierarchical view of 
how home ownership impacts loan applications and disbursements.
*/

SELECT 
	home_ownership AS HomeOwnership,
	COUNT(id) AS TotalLoanApplications ,
	SUM(loan_amount) AS TotalFundedAmount,
	SUM(total_payment) AS TotalAmountReceived
	FROM BankLoanData
	GROUP BY home_ownership
	ORDER BY home_ownership


						/* DASHBOARD 3 : DETAILS */

/*
The primary objective of the Details Dashboard is 
to provide a comprehensive and user-friendly interface 
for accessing vital loan data. 
It will serve as a one-stop solution for 
users seeking detailed insights into 
our loan portfolio, borrower profiles, and loan performance.
*/

SELECT * FROM BankLoanData