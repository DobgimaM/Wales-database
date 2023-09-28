# Wales-database
Database of practices in Wales

**Introduction**
This manual contains instructions for processing and reporting data from a database generated
using the following:
• General Practice Prescribing Data Extract for Wales
(http://www.primarycareservices.wales.nhs.uk/general-practice-prescribing-dataextrac)
• QOF Results for Wales, 2015 (https://www.gpcontract.co.uk/browse/WAL/15)
1.1 Program requirements
The program requires a computer with R Studio software installed and working. The database
should be installed and accessible in PostgreSQL (The program would require a password to
access the database).
1.2 Program functionality, input and output
To use this program, open Main file.R and start an R project in the existing directory. This
displays 4 windows, only 3 of which would be required:

• Top left (Main file.R): This is where codes would be executed. Place the cursor on line 16
to begin.
• Bottom left: Text and tabular output would be displayed here. If input is required,
instructions would be displayed here too. Type text and press the ‘Enter’ key on the
keyboard to add input.
• Bottom right: Graphical output would be displayed here.
Note: Some tables would open in a new tab for better appreciation of the data. Once you are
done examining the data, return to Main file.R and continue.
To run the code, place the cursor on line 16 and click the button at the top right of the
Main file.R window. Run the code until output is displayed or input is required, pausing between
runs until the stop sign ( ) disappears from the bottom left window. Continue running the
rest of the code from the Main file.R tab, entering input and viewing output as you go.
1.2.1 Color coded output
Codes that take a while to run are preceded by a warning before they are executed, with the
estimated run time highlighted in red ( ).
Important results are highlighted in yellow ( ). Time
estimates are based on an AMD Ryzen 7 processor, 8GB RAM computer.2.0 Output
Key term: Benzodiazepines a are widely used group of drugs prone to abuse through Doctor
shopping (Pradel et al., 2010).
2.1 Tables
- Wales: A table comparing the preserved counties of Wales by their total number of GP practices,
average spend per month, number of practices that have medication data, number of practices
that have Qof data and (a rough estimate of) the total number of patients in each practice.
- bz: A table of Benzodiazepine prescriptions, year of prescription and county by practices.
Prescriptions have been categorized into 0-80, 81-105, 106-126, and 127-214.
- bz1: A table of Benzodiazepine prescriptions by county.
2.2 Charts
- Plot of Hypertension against practice: A plot of hypertension rates in the practices from the
selected county. The user’s selected practice is highlighted in red, at the intersection of two red
lines. The Wales average is indicated by a green vertical line.
- Boxplot of test_data variables: This visualizes the hypertension rates and insulin prescription
rates, confirming that they are normally distributed (symmetrical about horizontal axis).
- Hypertension rate by counties: This chart illustrates hypertension rates in different counties in
Wales. Counties with rates above the calculated practice average are displayed in light red.
- Benzodiazepine prescriptions in Wales by year: Shows the quantity of Benzodiazepines
prescribed in Wales for 2013, 2014 and 2015. There was an increase in prescriptions after 2013.
- Bnz by county: A graph of Benzodiazepine prescriptions by county. Benzodiazepine prescription
is largely proportional to the county population. However, there were more prescriptions in Mid
Glamorgan than Clwyd, despite the latter having a larger population than the former.
2.3 Statistical output
- Central Limit Theorem: This tests if a sample is large enough (> 30). If so, it approximates a
normal distribution and can be evaluated using parametric tests. Otherwise, non-parametric
tests.


**References**
• Pradel, V., Delga, C., Rouby, F., Micallef, J., Lapeyre-Mestre M. (2010). Assessment of
abuse potential of benzodiazepines from a prescription database using ‘doctor shopping’
as an indicator. CNS Drugs 24, 611–620. https://doi.org/10.2165/11531570-000000000-
00000
• Wikipedia. (2021, November 26). Preserved counties of Wales. Preserved counties of
Wales - Wikipedia
