This script checks the table-spaces free pages less than 4000 and brings the free-pages to 10000 i.e.,

if FREE PAGES = 3000 , it will add 7000 and bring it to 10000
if FREE PAGES = 2000 , it will add 8000 and bring it to 10000

1. Install in the same Username you have privileges to execute the SYSIBMADM catalog views 
2. Change the db-name to your respective Database Name 
3. Change 4000 to your custom value if you want to change the LOWER MARK 
4. Change 10000 to your custom value depending on your server space and rate of data growth 
