SAVEPOINT before_table_creation;

-- Site Table
CREATE TABLE Site (
   site_id NUMBER(10) NOT NULL,
   site_name VARCHAR2(255),
   Address VARCHAR2(255),
   phone_number VARCHAR2(20),
   capacity NUMBER(10),
   category VARCHAR2(50),
   CONSTRAINT site_pk PRIMARY KEY (site_id)
);

-- Route Table
CREATE TABLE Route (
   route_id NUMBER(10) NOT NULL,
   Route_name VARCHAR2(255),
   CONSTRAINT route_pk PRIMARY KEY (route_id)
);

-- Stop Table
CREATE TABLE Stop (
   stop_id NUMBER(10) NOT NULL,
   stop_name VARCHAR2(255),
   CONSTRAINT stop_pk PRIMARY KEY (stop_id)
);

-- Fare Table
CREATE TABLE Fare (
   Passenger_type VARCHAR2(20) NOT NULL,
   fare_amount  NUMBER(10),
   CONSTRAINT fare_pk PRIMARY KEY (Passenger_type)
);

-- Event Table
CREATE TABLE Event (
   event_id NUMBER(10) NOT NULL,
   event_date DATE,
   event_time TIMESTAMP,
   event_participants VARCHAR2(255),
   event_name VARCHAR2(255),
   CONSTRAINT event_pk PRIMARY KEY (event_id)
);

-- Person Table
CREATE TABLE Person (
   person_id NUMBER(10) NOT NULL,
   first_name VARCHAR2(50),
   last_name VARCHAR2(50),
   Gender VARCHAR2(10),
   date_of_birth DATE,
   street_address VARCHAR2(255),
   City VARCHAR2(50),
   Province VARCHAR2(50),
   postal_code VARCHAR2(10),
   occupation VARCHAR2(50),
   CONSTRAINT person_pk PRIMARY KEY (person_id)
);


-- Contact_number Table
CREATE TABLE Contact_number (
   contact_id NUMBER(10) NOT NULL,
   person_id NUMBER(10),
   phone_number_type VARCHAR2(20),
   phone_number VARCHAR2(20) NOT NULL,
   CONSTRAINT contact_number_pk PRIMARY KEY (contact_id, person_id),
   CONSTRAINT contact_number_fk_person FOREIGN KEY (person_id) REFERENCES Person(person_id)
);


-- Maintenance_Personnel Table
CREATE TABLE Maintenance_Personnel (
   Maintenance_Personnel_id NUMBER(10) NOT NULL,
   Salary  NUMBER(10),
   years_of_service NUMBER(10),
   job_level VARCHAR2(20),
   area_of_specialisation VARCHAR2(50),
   CONSTRAINT maintenance_personnel_pk PRIMARY KEY (Maintenance_Personnel_id),
   CONSTRAINT maintenance_personnel_fk_person FOREIGN KEY (Maintenance_Personnel_id) REFERENCES Person(person_id)
);

-- Passenger Table
CREATE TABLE Passenger (
   Passenger_id NUMBER(10) NOT NULL,
   Passenger_type VARCHAR2(20),
   CONSTRAINT passenger_pk PRIMARY KEY (Passenger_id),
   CONSTRAINT passenger_fk_person FOREIGN KEY (Passenger_id) REFERENCES Person(person_id),
   CONSTRAINT passenger_fk_fare FOREIGN KEY (Passenger_type) REFERENCES Fare(Passenger_type)
);

-- Bus_driver Table
CREATE TABLE Bus_driver (
   driver_id NUMBER(10) NOT NULL,
   Salary  NUMBER(10),
   years_of_service NUMBER(10),
   CONSTRAINT bus_driver_pk PRIMARY KEY (driver_id),
   CONSTRAINT bus_driver_fk_person FOREIGN KEY (driver_id) REFERENCES Person(person_id)
);

-- Driving_Infraction Table
CREATE TABLE Driving_Infraction (
   driver_id NUMBER(10) NOT NULL,
   infraction_date DATE not null,
   infraction_type VARCHAR2(255),
   demerit_points NUMBER(10),
   Financial_penalty  NUMBER(10),
   CONSTRAINT driving_infraction_pk PRIMARY KEY (driver_id, infraction_date),
   CONSTRAINT driving_infraction_fk_driver FOREIGN KEY (driver_id) REFERENCES Bus_driver(driver_id)
);

-- Bus Table
CREATE TABLE Bus (
   Bus_id NUMBER(10) NOT NULL,
   years_in_operation NUMBER(10),
   Manufacturer VARCHAR2(255),
   number_of_seats NUMBER(10),
   type_of_fuel VARCHAR2(20),
   Advertising_revenue  NUMBER(10),
   route_id NUMBER(10),
   CONSTRAINT bus_pk PRIMARY KEY (Bus_id),
   CONSTRAINT bus_fk_route FOREIGN KEY (route_id) REFERENCES Route(route_id)
);


-- Bus_Maintenance Table
CREATE TABLE Bus_Maintenance (
   Maintenance_id NUMBER(10) NOT NULL,
   Bus_id NUMBER(10),
   fix_date DATE,
   CONSTRAINT bus_maintenance_pk PRIMARY KEY (Maintenance_id),
   CONSTRAINT bus_maintenance_fk_bus FOREIGN KEY (Bus_id) REFERENCES Bus(Bus_id)
);

-- Bus_Maintenance_Personnel_mapping Table
CREATE TABLE Bus_Maintenance_Personnel_mapping (
   Maintenance_id NUMBER(10) NOT NULL,
   Maintenance_Personnel_id NUMBER(10) NOT NULL,
   CONSTRAINT bus_maintenance_personnel_mapping_pk PRIMARY KEY (Maintenance_id, Maintenance_Personnel_id),
   CONSTRAINT bus_maintenance_personnel_mapping_fk_maintenance FOREIGN KEY (Maintenance_id) REFERENCES Bus_Maintenance(Maintenance_id),
   CONSTRAINT bus_maintenance_personnel_mapping_fk_personnel FOREIGN KEY (Maintenance_Personnel_id) REFERENCES Maintenance_Personnel(Maintenance_Personnel_id)
);

-- Contain Table
CREATE TABLE Contain (
   stop_id NUMBER(10),
   route_id NUMBER(10),
   contain_id NUMBER(10) NOT NULL,
   CONSTRAINT Contain_pk PRIMARY KEY (contain_id),
   CONSTRAINT Contain_fk_route FOREIGN KEY (route_id) REFERENCES Route(route_id),
   CONSTRAINT Contain_fk_stop FOREIGN KEY (stop_id) REFERENCES Stop(stop_id)
);

-- Site_event_mapping Table
CREATE TABLE Site_event_mapping (
   site_id NUMBER(10),
   event_id NUMBER(10),
   CONSTRAINT site_event_mapping_pk PRIMARY KEY (site_id, event_id),
   CONSTRAINT site_event_mapping_fk_site FOREIGN KEY (site_id) REFERENCES Site(site_id),
   CONSTRAINT site_event_mapping_fk_event FOREIGN KEY (event_id) REFERENCES Event(event_id)
);

-- Bus_driver_logs Table
CREATE TABLE Bus_driver_log (
   log_id NUMBER(10) NOT NULL,
   bus_id NUMBER(10),
   driver_id NUMBER(10),
   route_id NUMBER(10),
   start_time TIMESTAMP,
   end_time TIMESTAMP,
   CONSTRAINT bus_driver_log_pk PRIMARY KEY (log_id),
   CONSTRAINT bus_driver_log_fk_bus FOREIGN KEY (bus_id) REFERENCES Bus(Bus_id),
   CONSTRAINT bus_driver_log_fk_driver FOREIGN KEY (driver_id) REFERENCES Bus_driver(driver_id),
   CONSTRAINT bus_driver_log_fk_route FOREIGN KEY (route_id) REFERENCES Route(route_id)
);

-- Site_bus_stop_mapping Table
CREATE TABLE Site_bus_stop_mapping (
   site_id NUMBER(10),
   stop_id NUMBER(10),
   CONSTRAINT site_bus_stop_mapping_pk PRIMARY KEY (site_id, stop_id),
   CONSTRAINT site_bus_stop_mapping_fk_site FOREIGN KEY (site_id) REFERENCES Site(site_id),
   CONSTRAINT site_bus_stop_mapping_fk_stop FOREIGN KEY (stop_id) REFERENCES Stop(stop_id)
);


-- Schedule Table
CREATE TABLE Schedule (
   schedule_id NUMBER(10) NOT NULL,
   contain_id NUMBER(10),
   arrival_time TIMESTAMP,
   arrival_date DATE,
   bus_id NUMBER(10),
   CONSTRAINT schedule_pk PRIMARY KEY (schedule_id),
   CONSTRAINT schedule_fk_route FOREIGN KEY (contain_id) REFERENCES Contain(contain_id),
   CONSTRAINT schedule_fk_bus FOREIGN KEY (bus_id) REFERENCES Bus(Bus_id),
   CONSTRAINT arrival_time_check CHECK (
      TO_CHAR(arrival_time, 'HH24:MI:SS') BETWEEN '06:00:00' AND '23:00:00'
      AND arrival_date BETWEEN TO_DATE('2023-05-01', 'YYYY-MM-DD') AND TO_DATE('2023-05-07', 'YYYY-MM-DD')
   )
);

commit;
