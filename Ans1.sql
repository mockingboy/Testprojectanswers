-- Create LocationTypes table
CREATE TABLE LocationTypes (
    type_id INT PRIMARY KEY,
    type_name VARCHAR(255) NOT NULL
);

-- Insert data into LocationTypes
INSERT INTO LocationTypes (type_id, type_name) VALUES
(1, 'Building'),
(2, 'Level'),
(3, 'Room'),
(4, 'Pantry')
-- Add more types as needed

-- Create Locations table
CREATE TABLE Locations (
    location_id INT PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    type_id INT,
    parent_location_id INT,
    FOREIGN KEY (type_id) REFERENCES LocationTypes(type_id),
    FOREIGN KEY (parent_location_id) REFERENCES Locations(location_id)
);

-- Insert dummy data into Locations
INSERT INTO Locations (location_id, name, type_id, parent_location_id) VALUES
(1, 'Building A', 1, NULL),
(2, 'Carpark', 2, 1),
(3, 'Level 2', 2, 1),
(4, 'Room 201', 3, 3),
(5, 'Building B', 1, NULL),
(6, 'Level 1', 2, 5),
(7, 'Pantry', 4, 6),
(8, 'Room 101', 3, 6),
(9, 'Lobby C', 2, 8),
(10, 'Kios A', 3, 9),
(11, 'XXX', 3, 10);
-- Add more locations as needed

-- Query to retrieve data
SELECT Locations.location_id, Locations.name, LocationTypes.type_name, Parent.name AS parent_location
FROM Locations
JOIN LocationTypes ON Locations.type_id = LocationTypes.type_id
LEFT JOIN Locations Parent ON Locations.parent_location_id = Parent.location_id;
