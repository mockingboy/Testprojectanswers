-- Table to store health declaration form templates
CREATE TABLE HealthFormTemplates (
    TemplateID INT PRIMARY KEY,
    TemplateName VARCHAR(255) NOT NULL
);

-- Table to store dynamic fields in templates
CREATE TABLE TemplateFields (
    FieldID INT IDENTITY(1,1) PRIMARY KEY,
    TemplateID INT,
    FieldName VARCHAR(255) NOT NULL,
    FieldType VARCHAR(50) NOT NULL,
    FOREIGN KEY (TemplateID) REFERENCES HealthFormTemplates(TemplateID)
);

-- Table to store form submissions
CREATE TABLE FormSubmissions (
    SubmissionID INT IDENTITY(1,1) PRIMARY KEY,
    TemplateID INT,
    SubmissionDate DATE,
    VisitorName VARCHAR(255) NOT NULL,
    FOREIGN KEY (TemplateID) REFERENCES HealthFormTemplates(TemplateID)
);

-- Table to store values for dynamic fields in form submissions
CREATE TABLE SubmissionFieldValues (
    SubmissionID INT,
    FieldID INT,
    FieldValue VARCHAR(255),
    PRIMARY KEY (SubmissionID, FieldID),
    FOREIGN KEY (SubmissionID) REFERENCES FormSubmissions(SubmissionID),
    FOREIGN KEY (FieldID) REFERENCES TemplateFields(FieldID)
);

-- Dummy data for illustration purposes
INSERT INTO HealthFormTemplates (TemplateID, TemplateName) VALUES
(1, 'COVID-19 Health Declaration Form');

INSERT INTO TemplateFields (TemplateID, FieldName, FieldType) VALUES
(1, 'Name', 'text'),
(1, 'Business Email', 'text'),
(1, 'Company Name', 'text'),
(1, 'Designation', 'text'),
(1, 'Business Number', 'text'),
(1, 'License Plate', 'text'),
(1, 'NRIC/FIN Number', 'text'),
(1, 'Quarantine order', 'radio_select'),
(1, 'Close Contact', 'radio_select'),
(1, 'Fever', 'radio_select'),
(1, 'Agree Label Name', 'checkbox');

INSERT INTO FormSubmissions (TemplateID, SubmissionDate, VisitorName) VALUES
(1, '2024-01-07', 'John Doe');

INSERT INTO SubmissionFieldValues (SubmissionID, FieldID, FieldValue) VALUES
(1, 1, 'John Doe'),
(1, 2, 'john.doe@email.com'),
(1, 3, 'ABC Company'),
(1, 4, 'Manager'),
(1, 5, '123-456-7890'),
(1, 6, 'ABC123'),
(1, 7, '123456789X'),
(1, 8, 'Yes'),
(1, 9, 'No'),
(1, 10, 'Yes'),
(1, 11, 'Checked');

--more dummy data

-- Additional dummy data for form submissions
INSERT INTO FormSubmissions (TemplateID, SubmissionDate, VisitorName) VALUES
(1, '2024-01-08', 'Alice Johnson'),
(1, '2024-01-09', 'Bob Smith'),
(1, '2024-01-10', 'Eva Brown'),
(1, '2024-01-11', 'Charlie White'),
(1, '2024-01-12', 'Grace Davis'),
(1, '2024-01-13', 'Henry Miller'),
(1, '2024-01-14', 'Olivia Moore'),
(1, '2024-01-15', 'David Wilson'),
(1, '2024-01-16', 'Sophia Lee'),
(1, '2024-01-17', 'James Anderson');

-- Additional dummy data for field values
INSERT INTO SubmissionFieldValues (SubmissionID, FieldID, FieldValue) VALUES
(2, 1, 'Alice Johnson'),
(2, 2, 'alice@email.com'),
(2, 3, 'XYZ Corporation'),
(2, 4, 'Engineer'),
(2, 5, '987-654-3210'),
(2, 6, 'XYZ456'),
(2, 7, '987654321Y'),
(2, 8, 'No'),
(2, 9, 'Yes'),
(2, 10, 'No'),
(2, 11, 'Checked');

INSERT INTO SubmissionFieldValues (SubmissionID, FieldID, FieldValue) VALUES
(3, 1, 'Bob Smith'),
(3, 2, 'bob.smith@email.com'),
(3, 3, 'LMN Corporation'),
(3, 4, 'Analyst'),
(3, 5, '555-123-4567'),
(3, 6, 'LMN789'),
(3, 7, '555123456X'),
(3, 8, 'Yes'),
(3, 9, 'No'),
(3, 10, 'Yes'),
(3, 11, 'Checked');

-- Additional dummy data for form templates
INSERT INTO HealthFormTemplates (TemplateID, TemplateName) VALUES
(2, 'Visitor Information Form');

-- Additional dummy data for dynamic fields in template 2
INSERT INTO TemplateFields (TemplateID, FieldName, FieldType) VALUES
(2, 'Visitor Name', 'text'),
(2, 'Email', 'text'),
(2, 'Phone Number', 'text'),
(2, 'Company Name', 'text'),
(2, 'Purpose of Visit', 'text'),
(2, 'Meeting Room', 'text'),
(2, 'Checked In', 'radio_select'),
(2, 'Checked Out', 'radio_select'),
(2, 'Comments', 'text'),
(2, 'Agree Terms', 'checkbox');

-- Additional dummy data for form submissions using template 2
INSERT INTO FormSubmissions (TemplateID, SubmissionDate, VisitorName) VALUES
(2, '2024-01-18', 'Grace Wilson'),
(2, '2024-01-19', 'Daniel Harris'),
(2, '2024-01-20', 'Emma Turner'),
(2, '2024-01-21', 'Michael Clark'),
(2, '2024-01-22', 'Sophia Allen'),
(2, '2024-01-23', 'Alexander Hill'),
(2, '2024-01-24', 'Isabella Adams'),
(2, '2024-01-25', 'Jackson Brown'),
(2, '2024-01-26', 'Mia Davis'),
(2, '2024-01-27', 'Lucas Miller');

-- Additional dummy data for field values using template 2
INSERT INTO SubmissionFieldValues (SubmissionID, FieldID, FieldValue) VALUES
(11, 12, 'Grace Wilson'),
(11, 13, 'grace@email.com'),
(11, 14, '123-456-7890'),
(11, 15, 'ABC Corporation'),
(11, 16, 'Business Meeting'),
(11, 17, 'Meeting Room A'),
(11, 18, 'Yes'),
(11, 19, 'No'),
(11, 20, 'Good meeting!'),
(11, 21, 'Checked');



select * from FormSubmissions

select * from HealthFormTemplates

select * from SubmissionFieldValues

select * from TemplateFields

SELECT
    HS.SubmissionID,
    HS.TemplateID,
    HT.TemplateName,
    HS.SubmissionDate,
    HS.VisitorName,
    TF.FieldName,
    TF.FieldType,
    SFV.FieldValue
FROM
    FormSubmissions HS
LEFT JOIN HealthFormTemplates HT ON HS.TemplateID = HT.TemplateID
LEFT JOIN SubmissionFieldValues SFV ON HS.SubmissionID = SFV.SubmissionID
LEFT JOIN TemplateFields TF ON SFV.FieldID = TF.FieldID
ORDER BY
    HS.SubmissionID, TF.FieldID;
