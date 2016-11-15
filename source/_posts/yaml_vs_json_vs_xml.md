---
title: yaml vs json vs xml 
date: 2016-10-1 10:19:44
tags:
---
# yaml vs json vs xml 
<!-- more -->
---------xml
<?xml version="1.0" encoding="UTF-8" ?>
	<firstName>John</firstName>
	<lastName>Smith</lastName>
	<sex>male</sex>
	<age>25</age>
	<address>
		<streetAddress>21 2nd Street</streetAddress>
		<city>New York</city>
		<state>NY</state>
		<postalCode>10021</postalCode>
	</address>
	<phoneNumber>
		<type>home</type>
		<number>212 555-1234</number>
	</phoneNumber>
	<phoneNumber>
		<type>fax</type>
		<number>646 555-4567</number>
	</phoneNumber>
	
---------json
{
     "firstName": "John",
     "lastName": "Smith",
     "sex": "male",
     "age": 25,
     "address":
     {
         "streetAddress": "21 2nd Street",
         "city": "New York",
         "state": "NY",
         "postalCode": "10021"
     },
     "phoneNumber":
     [
         {
           "type": "home",
           "number": "212 555-1234"
         },
         {
           "type": "fax",
           "number": "646 555-4567"
         }
     ]
 }
------yaml
---
firstName: John
lastName: Smith
sex: male
age: 25
address:
    streetAddress: 21 2nd Street
    city: New York
    state: NY
    postalCode: 10021
phonenumber:
    - type: home
      number: 646 555-4567
    - type: fax
      number: 212 555-1234

----- pyton dict class
{'address': {'city': 'New York',
  'postalCode': 10021,
  'state': 'NY',
  'streetAddress': '21 2nd Street'},
 'age': 25,
 'firstName': 'John',
 'lastName': 'Smith',
 'phonenumber': [{'number': '646 555-4567', 'type': 'home'},
  {'number': '212 555-1234', 'type': 'fax'}],
 'sex': 'male'}
