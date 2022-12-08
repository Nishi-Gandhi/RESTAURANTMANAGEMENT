PURGE Recyclebin;
SET SERVEROUTPUT ON;

declare 
Is_true number;
begin 
Select count (*)
INTO Is_true
From  USER_TABLES WHERE TABLE_NAME = 'PAYMENTS';
IF Is_true >0
THEN 
EXECUTE IMMEDIATE 'DROP TABLE PAYMENTS';  
END IF;
END;

/
declare 
Is_true number;
begin 
Select count (*)
INTO Is_true
From  USER_TABLES WHERE TABLE_NAME = 'RATING';
IF Is_true >0
THEN 
EXECUTE IMMEDIATE 'DROP TABLE RATING';  
END IF;
END;
/
declare 
Is_true number;
begin 
Select count (*)
INTO Is_true
From  USER_TABLES WHERE TABLE_NAME = 'USERS';
IF Is_true >0
THEN 
EXECUTE IMMEDIATE 'DROP TABLE USERS';  
END IF;
END;
/
declare 
Is_true number;
begin 
Select count (*)
INTO Is_true
From  USER_TABLES WHERE TABLE_NAME = 'ORDERS';
IF Is_true >0
THEN 
EXECUTE IMMEDIATE 'DROP TABLE  ORDERS';  
END IF;
END;
/
declare 
Is_true number;
begin 
Select count (*)
INTO Is_true
From  USER_TABLES WHERE TABLE_NAME = 'ORDER_DETAILS';
IF Is_true >0
THEN 
EXECUTE IMMEDIATE 'DROP TABLE  ORDER_DETAILS';  
END IF;
END;
/


declare 
Is_true number;
begin 
Select count (*)
INTO Is_true
From  USER_TABLES WHERE TABLE_NAME = 'ITEM';
IF Is_true >0
THEN 
EXECUTE IMMEDIATE 'DROP TABLE  ITEM';  
END IF;
END;
/


declare 
Is_true number;
begin 
Select count (*)
INTO Is_true
From  USER_TABLES WHERE TABLE_NAME = 'EMPLOYEE';
IF Is_true >0
THEN 
EXECUTE IMMEDIATE 'DROP TABLE  EMPLOYEE';  
END IF;
END;
/
begin 
EXECUTE IMMEDIATE 'DROP TABLE RESTAURANT';
EXCEPTION
WHEN OTHERS
THEN NULL;
END;
/

Create Table ORDER_DETAILS( 
ORDER_DESC_ID Varchar(20)  Not Null PRIMARY KEY, 
ITEMS Varchar(50)
);
Create Table RESTAURANT( 
RESTAURANT_ID Varchar(10)  Not Null PRIMARY KEY, 
RESTAURANT_NAME Varchar(25) Not Null ,
RESTAURANT_LOCATION Varchar(25) Not Null,
RESTAURANT_CONTACT Varchar(10) Not Null,
RATING_AVG_VALUE Varchar(5) Not Null
);



Create Table ITEM (
ITEM_ID Varchar(10) Not Null Primary Key,
ITEM_NAME Varchar(25) Not Null,
ITEM_QUANTITY Varchar(10) Not Null,
ITEM_PRICE Varchar(10) Not Null,
RESTAURANT_ID Varchar(10) REFERENCES RESTAURANT(RESTAURANT_ID));





Create Table EMPLOYEE (
EMPLOYEE_ID Varchar(10) Not Null Primary Key,
EMPLOYEE_NAME Varchar(30) Not Null,
EMPLOYEE_CONTACT Varchar(10) Not Null,
EMPLOYEE_POSITION Varchar(10) Not Null,
EMPLOYEE_ADDRESS Varchar(20) Not Null,
RESTAURANT_ID Varchar(10) REFERENCES RESTAURANT(RESTAURANT_ID)
);

Create Table ORDERS ( 
ORDERS_ID Varchar(10) Not Null PRIMARY KEY, 
ORDERS_TYPE Varchar(10) Not Null,
ORDERS_PLACED_TIME timestamp,
RESTAURANT_ID Varchar(10) REFERENCES RESTAURANT(RESTAURANT_ID),
ITEM_ID Varchar(10) REFERENCES ITEM(ITEM_ID),
ORDER_DESC_ID Varchar(10) REFERENCES ORDER_DETAILS(ORDER_DESC_ID));

Create Table USERS ( 
USER_ID Varchar(10)  Not Null PRIMARY KEY, 
USER_NAME  Varchar(15) Not Null,
USER_CONTACT Varchar(10) Not Null,
ORDERS_ID Varchar(10) REFERENCES ORDERS(ORDERS_ID));

Create Table RATING(
RATING_ID Varchar(10) Not Null Primary Key,
RATING_COMMENTS Varchar(50) Not Null,
RATING_VALUE Varchar (5) Not Null,
RESTAURANT_ID Varchar(10) REFERENCES RESTAURANT(RESTAURANT_ID),
USER_ID Varchar(10) REFERENCES USERS(USER_ID));

Create Table PAYMENTS( 
PAYMENT_ID Varchar(10)  Not Null PRIMARY KEY, 
PAYMENT_TYPE Varchar(10) Not Null,
PAYMENT_STATUS Varchar(10) Not Null,
ORDERS_ID Varchar(10) REFERENCES ORDERS(ORDERS_ID),
RESTAURANT_ID Varchar(10) REFERENCES RESTAURANT(RESTAURANT_ID));

/* SELECT VIEW GRANTED TO OWNER*/
GRANT SELECT ON RESTAURANT TO RM_OWNER;
GRANT SELECT ON EMPLOYEE TO RM_OWNER;
GRANT SELECT ON ITEM TO RM_OWNER;
GRANT SELECT ON USERS TO RM_OWNER;
GRANT SELECT ON ORDERS TO RM_OWNER;
GRANT SELECT ON PAYMENTS TO RM_OWNER;
GRANT SELECT ON ORDER_DETAILS TO RM_OWNER;

/* INSERT UPDATE GRANTED TO OWNER*/
GRANT INSERT, UPDATE ON RESTAURANT  TO RM_OWNER;
GRANT INSERT, UPDATE ON ORDERS  TO RM_OWNER;
GRANT INSERT, UPDATE ON ITEM TO RM_OWNER;
GRANT INSERT, UPDATE ON PAYMENTS  TO RM_OWNER;
GRANT INSERT, UPDATE ON USERS TO RM_OWNER;
GRANT INSERT, UPDATE ON EMPLOYEE TO RM_OWNER;
GRANT INSERT, UPDATE ON ORDER_DETAILS TO RM_OWNER;
GRANT INSERT, UPDATE ON RATING TO RM_OWNER;


/* SELECT VIEW GRANTED TO MANAGER*/
GRANT SELECT ON RESTAURANT TO RM_MANAGER;
GRANT SELECT ON ITEM TO RM_MANAGER;
GRANT SELECT ON ORDERS TO RM_MANAGER;
GRANT SELECT ON ORDER_DETAILS TO RM_MANAGER;

/* SELECT VIEW GRANTED TO USER*/
GRANT SELECT ON RATING TO RM_USER;
GRANT SELECT ON PAYMENTS TO RM_USER;
GRANT SELECT ON ORDER_DETAILS TO RM_USER;


/* view restricted employee details*/
Create OR REPLACE view  RESTRICTED_EMP_details
As 
Select EMPLOYEE_ID,
EMPLOYEE_NAME,
EMPLOYEE_CONTACT,
EMPLOYEE_POSITION,
EMPLOYEE_ADDRESS ,
RESTAURANT_ID
From EMPLOYEE;

GRANT SELECT ON RESTRICTED_EMP_details TO RM_OWNER;

/* VIEW FOR RATINGS WITHOUT LETTING USERID*/
Create OR REPLACE view rating_details 
As 
Select RATING_ID,
RATING_COMMENTS,
RATING_VALUE ,
RESTAURANT_ID
From RATING;
 
GRANT SELECT ON rating_details TO RM_OWNER;
 
/*VIEW FOR KNOWING THE ORDER PLACED TIME*/
Create or REPLACE view WAITLIST_TIME
As 
Select ORDERS_ID,
ORDERS_PLACED_TIME
From ORDERS;

/*VIEW FOR SEEING PAYMENT STATUS OF THE ORDERS*/
CREATE OR REPLACE VIEW PAYMENT_STATUS AS
SELECT B.ORDERS_ID,
       B.RESTAURANT_ID,
       A.PAYMENT_ID,
       A.PAYMENT_STATUS
FROM PAYMENTS A
INNER JOIN ORDERS B
        ON A.ORDERS_ID = B.ORDERS_ID;

GRANT SELECT ON PAYMENT_STATUS TO RM_OWNER;
GRANT SELECT ON PAYMENT_STATUS TO RM_USER;

/*VIEW FOR OWNER TO SEE USER DETAILS*/
CREATE OR REPLACE VIEW USER_DETAILS AS
SELECT USER_ID,
USER_NAME,
USER_CONTACT,
ORDERS_ID
FROM USERS;
GRANT SELECT ON USER_DETAILS TO RM_OWNER;

/*VIEW FOR MANAGER TO CHECK INVENTORY*/
CREATE OR REPLACE VIEW ITEM_STATUS AS
SELECT ITEM_ID,
ITEM_QUANTITY,
RESTAURANT_ID
FROM ITEM;
GRANT SELECT ON ITEM_STATUS TO RM_MANAGER;

GRANT SELECT ON WAITLIST_TIME TO RM_USER;
GRANT INSERT, UPDATE ON RATING TO RM_USER;

COMMIT;
