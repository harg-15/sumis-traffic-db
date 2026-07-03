-- ============================================================
-- SUMIS - Complete Seed Data
-- File: 04_seed_data.sql
-- Run AFTER 03_views_indexes_analytics.sql
-- ============================================================

-- ========================
-- Zones (10 total)
-- ========================
INSERT INTO Zone (ZoneName) VALUES
    ('North Zone'),
    ('South Zone'),
    ('East Zone'),
    ('West Zone'),
    ('Central Zone'),
    ('Industrial Zone'),
    ('Airport Zone'),
    ('Old City Zone'),
    ('Riverside Zone'),
    ('Tech Park Zone');

-- ========================
-- VehicleTypes
-- ========================
INSERT INTO VehicleType (TypeName) VALUES
    ('Private'),
    ('Commercial'),
    ('Emergency');

-- ========================
-- Owners (50 total)
-- ========================
INSERT INTO Owner (Name, Address, ContactNo) VALUES
    ('Rohan Mehta',      '12 MG Road, Ahmedabad',              '9876543210'),
    ('Siddharth Das',    '45 SG Highway, Surat',               '9876543211'),
    ('Keval Valand',     '78 CG Road, Vadodara',               '9876543212'),
    ('Nisha Sharma',     '22 Ring Road, Rajkot',               '9876543213'),
    ('Ananya Mehta',     '10 Relief Road, Gandhinagar',        '9876543214'),
    ('Raj Patel',        '15 Ashram Road, Ahmedabad',          '9000000001'),
    ('Priya Shah',       '22 Satellite Road, Ahmedabad',       '9000000002'),
    ('Amit Verma',       '8 Navrangpura, Ahmedabad',           '9000000003'),
    ('Sneha Joshi',      '34 Vastrapur, Ahmedabad',            '9000000004'),
    ('Karan Mehta',      '12 Bopal, Ahmedabad',                '9000000005'),
    ('Pooja Desai',      '5 Gota, Ahmedabad',                  '9000000006'),
    ('Vivek Nair',       '18 Maninagar, Ahmedabad',            '9000000007'),
    ('Ritu Singh',       '9 Chandkheda, Ahmedabad',            '9000000008'),
    ('Nikhil Jain',      '27 Thaltej, Ahmedabad',              '9000000009'),
    ('Meena Trivedi',    '3 Paldi, Ahmedabad',                 '9000000010'),
    ('Suresh Kumar',     '45 Naroda, Ahmedabad',               '9000000011'),
    ('Deepa Rao',        '11 Nikol, Ahmedabad',                '9000000012'),
    ('Arun Mishra',      '6 Vastral, Ahmedabad',               '9000000013'),
    ('Kavita Pandey',    '19 Odhav, Ahmedabad',                '9000000014'),
    ('Mohit Sharma',     '33 Asarwa, Ahmedabad',               '9000000015'),
    ('Ankit Gupta',      '7 Sabarmati, Ahmedabad',             '9000000016'),
    ('Divya Pillai',     '21 Ranip, Ahmedabad',                '9000000017'),
    ('Sanjay Tiwari',    '14 Narol, Ahmedabad',                '9000000018'),
    ('Rohini Patil',     '29 Vatva, Ahmedabad',                '9000000019'),
    ('Vishal Agarwal',   '2 Kathwada, Ahmedabad',              '9000000020'),
    ('Nisha Bhatt',      '16 Sarkhej, Ahmedabad',              '9000000021'),
    ('Rahul Kapoor',     '38 Prahlad Nagar, Ahmedabad',        '9000000022'),
    ('Swati Malhotra',   '10 Drive-In Road, Ahmedabad',        '9000000023'),
    ('Ajay Chauhan',     '24 Mithakhali, Ahmedabad',           '9000000024'),
    ('Geeta Iyer',       '17 Ellisbridge, Ahmedabad',          '9000000025'),
    ('Rajesh Dubey',     '43 Ambawadi, Ahmedabad',             '9000000026'),
    ('Sunita Yadav',     '6 Kankaria, Ahmedabad',              '9000000027'),
    ('Manoj Srivastava', '31 Bapunagar, Ahmedabad',            '9000000028'),
    ('Leena Ghosh',      '13 Meghaninagar, Ahmedabad',         '9000000029'),
    ('Tarun Bajaj',      '25 Rakhial, Ahmedabad',              '9000000030'),
    ('Farah Khan',       '8 Juhapura, Ahmedabad',              '9000000031'),
    ('Siddharth Rao',    '19 Vejalpur, Ahmedabad',             '9000000032'),
    ('Preethi Menon',    '42 Jodhpur, Ahmedabad',              '9000000033'),
    ('Gaurav Saxena',    '11 Bodakdev, Ahmedabad',             '9000000034'),
    ('Ankita Misra',     '27 Science City Road, Ahmedabad',    '9000000035'),
    ('Hemant Joshi',     '5 SP Ring Road, Ahmedabad',          '9000000036'),
    ('Pallavi Reddy',    '33 132 Ring Road, Ahmedabad',        '9000000037'),
    ('Vinod Nambiar',    '18 Judges Bungalow Road, Ahmedabad', '9000000038'),
    ('Shruti Banerjee',  '9 Urjanagar, Ahmedabad',             '9000000039'),
    ('Nitin Kulkarni',   '22 Ghatlodiya, Ahmedabad',           '9000000040'),
    ('Smita Pawar',      '14 Ghatlodia, Ahmedabad',            '9000000041'),
    ('Ravi Shankar',     '36 New CG Road, Ahmedabad',          '9000000042'),
    ('Usha Nair',        '7 Prahladnagar, Ahmedabad',          '9000000043'),
    ('Deepak Verma',     '28 Sindhu Bhavan Road, Ahmedabad',   '9000000044'),
    ('Manjula Iyer',     '15 SoBo Center, Ahmedabad',          '9000000045');

-- ========================
-- Vehicles (50 total)
-- ========================
INSERT INTO Vehicle (RegistrationNo, Model, Year, OwnerID, VehicleTypeID, ZoneID) VALUES
    ('GJ01AB1234', 'Honda City',      2020, 1,  1, 1),
    ('GJ01CD5678', 'Tata Nexon',      2019, 2,  1, 2),
    ('GJ02EF9012', 'Mahindra XUV',    2021, 3,  2, 3),
    ('GJ03GH3456', 'Maruti Swift',    2018, 4,  1, 4),
    ('GJ04IJ7890', 'Hyundai i20',     2022, 5,  1, 5),
    ('GJ05KL1111', 'Toyota Innova',   2019, 6,  2, 1),
    ('GJ05MN2222', 'Suzuki Baleno',   2020, 7,  1, 2),
    ('GJ06OP3333', 'Honda Amaze',     2021, 8,  1, 3),
    ('GJ06QR4444', 'Ford EcoSport',   2018, 9,  1, 4),
    ('GJ07ST5555', 'Kia Seltos',      2022, 10, 1, 5),
    ('GJ07UV6666', 'Renault Kwid',    2020, 11, 1, 6),
    ('GJ08WX7777', 'VW Polo',         2019, 12, 1, 7),
    ('GJ08YZ8888', 'Skoda Rapid',     2021, 13, 1, 8),
    ('GJ09AB9999', 'Nissan Magnite',  2022, 14, 1, 9),
    ('GJ09CD0001', 'MG Hector',       2023, 15, 1, 10),
    ('GJ10EF0002', 'Tata Harrier',    2021, 16, 2, 1),
    ('GJ10GH0003', 'Mahindra Thar',   2022, 17, 2, 2),
    ('GJ11IJ0004', 'Hyundai Creta',   2020, 18, 1, 3),
    ('GJ11KL0005', 'Toyota Fortuner', 2021, 19, 2, 4),
    ('GJ12MN0006', 'Honda Jazz',      2019, 20, 1, 5),
    ('GJ12OP0007', 'Maruti Ertiga',   2020, 21, 2, 6),
    ('GJ13QR0008', 'Tata Tigor',      2018, 22, 1, 7),
    ('GJ13ST0009', 'Hyundai Venue',   2022, 23, 1, 8),
    ('GJ14UV0010', 'Kia Sonet',       2021, 24, 1, 9),
    ('GJ14WX0011', 'Maruti Fronx',    2023, 25, 1, 10),
    ('GJ15YZ0012', 'Tata Punch',      2022, 26, 1, 1),
    ('GJ15AB0013', 'Honda WRV',       2020, 27, 1, 2),
    ('GJ16CD0014', 'Renault Triber',  2021, 28, 2, 3),
    ('GJ16EF0015', 'Nissan Sunny',    2019, 29, 1, 4),
    ('GJ17GH0016', 'VW Vento',        2020, 30, 1, 5),
    ('GJ17IJ0017', 'Skoda Slavia',    2022, 31, 1, 6),
    ('GJ18KL0018', 'Toyota Glanza',   2021, 32, 1, 7),
    ('GJ18MN0019', 'MG Astor',        2022, 33, 1, 8),
    ('GJ19OP0020', 'Hyundai i10',     2020, 34, 1, 9),
    ('GJ19QR0021', 'Maruti Alto',     2018, 35, 1, 10),
    ('GJ20ST0022', 'Tata Safari',     2023, 36, 2, 1),
    ('GJ20UV0023', 'Honda City 5th',  2022, 37, 1, 2),
    ('GJ21WX0024', 'Hyundai Exter',   2023, 38, 1, 3),
    ('GJ21YZ0025', 'Maruti Brezza',   2021, 39, 1, 4),
    ('GJ22AB0026', 'Tata Altroz',     2022, 40, 1, 5),
    ('GJ22CD0027', 'Toyota Urban',    2021, 41, 1, 6),
    ('GJ23EF0028', 'Kia Carnival',    2022, 42, 2, 7),
    ('GJ23GH0029', 'MG Comet',        2023, 43, 1, 8),
    ('GJ24IJ0030', 'Hyundai Tucson',  2022, 44, 2, 9),
    ('GJ24KL0031', 'Honda Elevate',   2023, 45, 1, 10),
    ('GJ25MN0032', 'Ambulance Van',   2020, 6,  3, 1),
    ('GJ25OP0033', 'Police Jeep',     2021, 7,  3, 2),
    ('GJ26QR0034', 'Fire Truck',      2019, 8,  3, 3),
    ('GJ26ST0035', 'Cargo Truck',     2018, 9,  2, 4),
    ('GJ27UV0036', 'Delivery Van',    2020, 10, 2, 5);

-- ========================
-- Roads (15 total)
-- ========================
INSERT INTO Road (RoadName, Length, ZoneID) VALUES
    ('MG Road',                      5.2,  1),
    ('SG Highway',                   12.5, 2),
    ('Ring Road',                    8.0,  3),
    ('CG Road',                      6.3,  4),
    ('Relief Road',                  4.1,  5),
    ('SP Ring Road',                 22.0, 6),
    ('132 Feet Ring Road',           18.5, 7),
    ('Sarkhej Gandhinagar Highway',  35.0, 8),
    ('Judges Bungalow Road',         4.8,  9),
    ('Sindhu Bhavan Road',           6.2,  10),
    ('Drive-In Road',                5.5,  1),
    ('Ashram Road',                  9.0,  2),
    ('Nehru Bridge Road',            3.2,  3),
    ('Chimanlal Girdharlal Road',    4.0,  4),
    ('Navrangpura Road',             3.8,  5);

-- ========================
-- Intersections (15 total)
-- ========================
INSERT INTO Intersection (IntersectionName) VALUES
    ('Paldi Junction'),
    ('Navrangpura Cross'),
    ('Satellite Circle'),
    ('Vastrapur Lake Cross'),
    ('ISCON Junction'),
    ('Nehru Bridge Junction'),
    ('Law Garden Cross'),
    ('Gujarat University Cross'),
    ('Swami Vivekanand Cross'),
    ('Vijay Cross Road'),
    ('Stadium Cross Road'),
    ('Girish Cold Drinks Cross'),
    ('Polytechnic Cross'),
    ('Commerce Six Roads'),
    ('Panjarapole Cross');

-- ========================
-- IntersectionRoad mappings
-- ========================
INSERT INTO IntersectionRoad (IntersectionID, RoadID) VALUES
    (1, 1), (1, 2),
    (2, 2), (2, 3),
    (3, 3), (3, 4),
    (4, 4), (4, 5),
    (5, 1), (5, 5),
    (6, 6), (6, 7),
    (7, 7), (7, 8),
    (8, 8), (8, 9),
    (9, 9), (9, 10),
    (10, 10), (10, 6),
    (11, 1), (11, 6),
    (12, 2), (12, 7),
    (13, 3), (13, 8),
    (14, 4), (14, 9),
    (15, 5), (15, 10);

-- ========================
-- TrafficSignals (15 total)
-- ========================
INSERT INTO TrafficSignal (IntersectionID, Status, LastMaintenanceDate) VALUES
    (1,  'Active',  '2025-12-01'),
    (2,  'Active',    '2025-11-15'),
    (3,  'Active', '2025-10-20'),
    (4,  'Active',  '2026-01-05'),
    (5,  'Active',    '2025-09-30'),
    (6,  'Active',  '2025-12-10'),
    (7,  'Active',    '2025-11-20'),
    (8,  'Active', '2026-01-15'),
    (9,  'Active',  '2026-01-25'),
    (10, 'Active',    '2025-10-05'),
    (11, 'Active',  '2026-02-01'),
    (12, 'Active', '2025-12-20'),
    (13, 'Active',    '2026-01-10'),
    (14, 'Active',  '2025-11-30'),
    (15, 'Active', '2026-02-15');

-- ========================
-- Cameras (15 total)
-- ========================
INSERT INTO Camera (RoadID, IntersectionID, InstallationDate, Status) VALUES
    (1,    NULL, '2023-01-10', 'Active'),
    (2,    NULL, '2023-03-15', 'Active'),
    (NULL, 1,    '2023-06-20', 'Active'),
    (NULL, 2,    '2024-01-01', 'Active'),
    (3,    NULL, '2024-05-10', 'Active'),
    (6,    NULL, '2023-07-01', 'Active'),
    (7,    NULL, '2023-08-15', 'Active'),
    (8,    NULL, '2024-02-10', 'Active'),
    (NULL, 6,    '2024-03-01', 'Active'),
    (NULL, 7,    '2024-04-20', 'Active'),
    (9,    NULL, '2023-09-05', 'Active'),
    (10,   NULL, '2024-01-15', 'Active'),
    (NULL, 8,    '2023-11-11', 'Active'),
    (NULL, 9,    '2024-05-05', 'Active'),
    (NULL, 10,   '2024-06-18', 'Active');

-- ========================
-- ViolationTypes
-- ========================
INSERT INTO ViolationType (Description, BaseFineAmount) VALUES
    ('Over Speeding',                1500.00),
    ('Red Light Jump',               2000.00),
    ('Wrong Side Driving',           1000.00),
    ('No Helmet',                     500.00),
    ('Mobile Phone While Driving',   1500.00);

-- ========================
-- Violations (~50 total, trigger auto-creates Fines)
-- ========================
INSERT INTO Violation (VehicleID, CameraID, ViolationTypeID, DateTime) VALUES
    (1,  1,  1, '2026-01-10 09:15:00'),
    (1,  2,  2, '2026-01-12 11:30:00'),
    (2,  3,  3, '2026-01-15 14:00:00'),
    (3,  4,  4, '2026-01-20 08:45:00'),
    (4,  1,  5, '2026-01-22 17:00:00'),
    (1,  5,  1, '2026-01-25 10:00:00'),
    (2,  2,  2, '2026-02-01 13:20:00'),
    (5,  3,  1, '2026-02-05 09:00:00'),
    (6,  6,  1, '2026-01-05 08:10:00'),
    (7,  7,  2, '2026-01-06 09:20:00'),
    (8,  8,  3, '2026-01-07 10:30:00'),
    (9,  9,  4, '2026-01-08 11:00:00'),
    (10, 10, 5, '2026-01-09 12:15:00'),
    (11, 1,  1, '2026-01-10 13:00:00'),
    (12, 2,  2, '2026-01-11 14:20:00'),
    (13, 3,  3, '2026-01-12 15:30:00'),
    (14, 4,  4, '2026-01-13 16:00:00'),
    (15, 5,  5, '2026-01-14 17:10:00'),
    (16, 6,  1, '2026-01-15 08:00:00'),
    (17, 7,  2, '2026-01-16 09:30:00'),
    (18, 8,  3, '2026-01-17 10:00:00'),
    (19, 9,  1, '2026-01-18 11:20:00'),
    (20, 10, 2, '2026-01-19 12:00:00'),
    (21, 1,  4, '2026-01-20 13:30:00'),
    (22, 2,  5, '2026-01-21 14:00:00'),
    (23, 3,  1, '2026-01-22 15:10:00'),
    (24, 4,  2, '2026-01-23 16:20:00'),
    (25, 5,  3, '2026-01-24 08:45:00'),
    (26, 6,  4, '2026-01-25 09:15:00'),
    (27, 7,  5, '2026-01-26 10:50:00'),
    (28, 8,  1, '2026-01-27 11:30:00'),
    (29, 9,  2, '2026-01-28 12:40:00'),
    (30, 10, 3, '2026-01-29 13:50:00'),
    (31, 1,  4, '2026-01-30 14:10:00'),
    (32, 2,  5, '2026-01-31 15:20:00'),
    (33, 3,  1, '2026-02-01 08:30:00'),
    (34, 4,  2, '2026-02-02 09:40:00'),
    (35, 5,  3, '2026-02-03 10:50:00'),
    (36, 6,  1, '2026-02-04 11:00:00'),
    (37, 7,  2, '2026-02-05 12:10:00'),
    (38, 8,  4, '2026-02-06 13:20:00'),
    (39, 9,  5, '2026-02-07 14:30:00'),
    (40, 10, 1, '2026-02-08 15:40:00'),
    (41, 1,  2, '2026-02-09 08:00:00'),
    (42, 2,  3, '2026-02-10 09:10:00'),
    (1,  3,  2, '2026-02-11 10:20:00'),
    (1,  4,  4, '2026-02-12 11:30:00'),
    (2,  5,  1, '2026-02-13 12:40:00'),
    (3,  6,  5, '2026-02-14 13:50:00'),
    (4,  7,  2, '2026-02-15 14:00:00');

-- ========================
-- Payments (trigger auto-marks Fine as Paid)
-- ========================
INSERT INTO Payment (FineID, PaymentDate, Mode, AmountPaid) VALUES
    (1,  '2026-01-20', 'Online', 1500.00),
    (3,  '2026-01-25', 'Cash',   1000.00),
    (5,  '2026-02-01', 'Online', 1500.00),
    (9,  '2026-01-25', 'Online',  500.00),
    (10, '2026-01-26', 'Card',   1500.00),
    (11, '2026-01-27', 'Cash',   1500.00),
    (12, '2026-01-28', 'Online', 2000.00),
    (13, '2026-01-29', 'Card',   1000.00),
    (14, '2026-01-30', 'Online',  500.00),
    (15, '2026-01-31', 'Cash',   1500.00),
    (16, '2026-02-01', 'Online', 1500.00),
    (17, '2026-02-02', 'Card',   2000.00),
    (18, '2026-02-03', 'Online', 1000.00),
    (19, '2026-02-04', 'Cash',   1500.00),
    (20, '2026-02-05', 'Online', 2000.00),
    (21, '2026-02-06', 'Card',    500.00),
    (22, '2026-02-07', 'Online', 1500.00),
    (23, '2026-02-08', 'Cash',   1500.00),
    (24, '2026-02-09', 'Online', 2000.00),
    (25, '2026-02-10', 'Card',   1000.00),
    (26, '2026-02-11', 'Online',  500.00),
    (27, '2026-02-12', 'Cash',   1500.00),
    (28, '2026-02-13', 'Online', 1500.00);

-- ========================
-- Accidents (30 total)
-- ========================
INSERT INTO Accident (IntersectionID, DateTime, SeverityLevel) VALUES
    (1,  '2026-01-08 07:30:00', 'High'),
    (2,  '2026-01-14 12:15:00', 'Medium'),
    (1,  '2026-01-22 18:45:00', 'Low'),
    (3,  '2026-02-02 08:00:00', 'High'),
    (1,  '2026-02-10 16:30:00', 'Medium'),
    (2,  '2026-01-05 06:30:00', 'High'),
    (3,  '2026-01-07 07:15:00', 'Medium'),
    (4,  '2026-01-09 08:00:00', 'Low'),
    (5,  '2026-01-11 09:30:00', 'High'),
    (1,  '2026-01-13 10:45:00', 'Medium'),
    (6,  '2026-01-15 11:00:00', 'High'),
    (7,  '2026-01-17 12:20:00', 'Low'),
    (8,  '2026-01-19 13:30:00', 'Medium'),
    (9,  '2026-01-21 14:45:00', 'High'),
    (10, '2026-01-23 15:00:00', 'Low'),
    (2,  '2026-01-25 16:10:00', 'Medium'),
    (3,  '2026-01-27 07:00:00', 'High'),
    (1,  '2026-01-29 08:30:00', 'Low'),
    (4,  '2026-01-31 09:45:00', 'Medium'),
    (5,  '2026-02-02 10:00:00', 'High'),
    (6,  '2026-02-04 11:15:00', 'Low'),
    (7,  '2026-02-06 12:30:00', 'Medium'),
    (8,  '2026-02-08 13:45:00', 'High'),
    (9,  '2026-02-10 14:00:00', 'Low'),
    (10, '2026-02-12 15:20:00', 'Medium'),
    (1,  '2026-02-14 07:30:00', 'High'),
    (2,  '2026-02-16 08:45:00', 'Medium'),
    (3,  '2026-02-18 09:00:00', 'Low'),
    (4,  '2026-02-20 10:15:00', 'High'),
    (5,  '2026-02-22 11:30:00', 'Medium');

-- ========================
-- AccidentVehicle mappings
-- ========================
INSERT INTO AccidentVehicle (AccidentID, VehicleID, DamageLevel) VALUES
    (1,  1,  'Severe'),
    (1,  2,  'Moderate'),
    (2,  3,  'Minor'),
    (3,  4,  'Moderate'),
    (4,  5,  'Severe'),
    (5,  1,  'Minor'),
    (6,  6,  'Severe'),
    (7,  7,  'Minor'),
    (8,  8,  'Moderate'),
    (9,  9,  'Severe'),
    (10, 10, 'Minor'),
    (11, 11, 'Moderate'),
    (12, 12, 'Severe');

-- ========================
-- Congestion Logs (38 total)
-- ========================
INSERT INTO Congestion_Log (RoadID, Timestamp, VehicleCount, CongestionLevel) VALUES
    (1, '2026-02-28 08:00:00', 250, 'High'),
    (1, '2026-02-28 10:00:00', 180, 'Medium'),
    (2, '2026-02-28 08:30:00', 310, 'High'),
    (3, '2026-02-28 09:00:00', 90,  'Low'),
    (1, '2026-03-01 08:00:00', 270, 'High'),
    (2, '2026-03-01 09:00:00', 200, 'Medium'),
    (4, '2026-03-02 08:00:00', 150, 'Medium'),
    (5, '2026-03-03 08:00:00', 60,  'Low'),
    (1, '2026-02-24 08:00:00', 290, 'High'),
    (2, '2026-02-24 08:30:00', 220, 'High'),
    (3, '2026-02-24 09:00:00', 110, 'Medium'),
    (4, '2026-02-24 09:30:00', 75,  'Low'),
    (5, '2026-02-24 10:00:00', 55,  'Low'),
    (6, '2026-02-25 08:00:00', 340, 'High'),
    (7, '2026-02-25 08:30:00', 260, 'High'),
    (8, '2026-02-25 09:00:00', 130, 'Medium'),
    (9, '2026-02-25 09:30:00', 90,  'Medium'),
    (10,'2026-02-25 10:00:00', 60,  'Low'),
    (1, '2026-02-26 08:00:00', 310, 'High'),
    (2, '2026-02-26 08:30:00', 240, 'High'),
    (3, '2026-02-26 09:00:00', 145, 'Medium'),
    (6, '2026-02-26 09:30:00', 195, 'Medium'),
    (7, '2026-02-26 10:00:00', 280, 'High'),
    (1, '2026-02-27 08:00:00', 265, 'High'),
    (2, '2026-02-27 08:30:00', 205, 'Medium'),
    (4, '2026-02-27 09:00:00', 88,  'Low'),
    (5, '2026-02-27 09:30:00', 72,  'Low'),
    (8, '2026-02-27 10:00:00', 155, 'Medium'),
    (1, '2026-03-01 17:00:00', 320, 'High'),
    (2, '2026-03-01 17:30:00', 295, 'High'),
    (6, '2026-03-02 08:00:00', 230, 'High'),
    (7, '2026-03-02 17:00:00', 275, 'High'),
    (3, '2026-03-03 08:00:00', 120, 'Medium'),
    (4, '2026-03-03 17:00:00', 95,  'Medium'),
    (9, '2026-03-04 08:00:00', 80,  'Low'),
    (10,'2026-03-04 17:00:00', 65,  'Low'),
    (1, '2026-03-05 08:00:00', 300, 'High'),
    (2, '2026-03-05 08:30:00', 270, 'High');

-- ========================
-- UserAccounts
-- ========================
-- Password format: '<salt>:<sha256(salt+plaintext)>'. Plaintext: admin123 / officer123 / finance123 / analyst123
INSERT INTO UserAccount (Username, Password, Role) VALUES
    ('admin',    'cfb0ef6a160ecf7cd32b7073cbd397d6:4bde4cbe74749c646ff17a8d0985fb173039ae35ff3e1f7a9c5f4d3783c831f8', 'Admin'),
    ('officer1', 'c98fa385f92cc05723be2f8a43f4e911:391371c3816d46b57a7cfe4f77ad3001e662041f19fd02ad4a078f41eb791098', 'Officer'),
    ('finance1', '612b025d6cd9f69d8345e5d162a19d2b:3c805c185170480474da00a5a607bdd7c6d763a7788b1ba437eef1c71459a635', 'Finance'),
    ('analyst1', '84b26043780301f82795caac4f820f44:a5df606b3b1d9011e9b69f91ed8a039be2356ca63296abed75274df45d55b69b', 'Analyst');

SELECT 'Seed data inserted successfully.' AS status;