CREATE DATABASE crm_donor_analysis;
USE crm_donor_analysis;
SELECT * FROM donors LIMIT 10;
SELECT 
  DonorID, 
  LastDonationDate, 
  STR_TO_DATE(LastDonationDate, '%m/%d/%Y') AS DonationDate
FROM donors
LIMIT 5;
select * from donors;
SELECT DonorID,
       FirstName,
       LastName,
       EngagementScore,
       CASE 
         WHEN EngagementScore >= 75 THEN 'Highly Engaged'
         WHEN EngagementScore BETWEEN 40 AND 74 THEN 'Moderately Engaged'
         ELSE 'Low Engagement'
       END AS Engagement_Level
FROM donors;

SELECT DonorID, FirstName, LastName, TotalAmountDonated
FROM donors
ORDER BY TotalAmountDonated DESC
LIMIT 10;

SELECT DonorID, FirstName, LastName, STR_TO_DATE(LastDonationDate, '%m/%d/%Y') AS DonationDate
FROM donors
WHERE STR_TO_DATE(LastDonationDate, '%m/%d/%Y') < DATE_SUB(CURDATE(), INTERVAL 12 MONTH);

SELECT State,
       COUNT(*) AS DonorCount,
       ROUND(SUM(TotalAmountDonated), 2) AS TotalDonated,
       ROUND(AVG(EngagementScore), 2) AS AvgEngagement
FROM donors
GROUP BY State
ORDER BY TotalDonated DESC;

SELECT 
  MONTH(STR_TO_DATE(LastDonationDate, '%m/%d/%Y')) AS DonationMonth,
  COUNT(*) AS TotalDonations
FROM donors
GROUP BY DonationMonth
ORDER BY DonationMonth;

CREATE TABLE donor_info AS
SELECT DonorID, FirstName, LastName, Email, Phone, City, State, ZipCode
FROM donors;

CREATE TABLE donation_history AS
SELECT DonorID, 
       STR_TO_DATE(LastDonationDate, '%m/%d/%Y') AS LastDonationDate, 
       TotalGifts, 
       TotalAmountDonated
FROM donors;

CREATE TABLE donor_engagement AS
SELECT DonorID, EventParticipation, EngagementScore
FROM donors;

SELECT 
  i.FirstName, i.LastName, i.Email,
  e.EventParticipation, e.EngagementScore
FROM donor_info i
JOIN donor_engagement e ON i.DonorID = e.DonorID;


SELECT 
  i.FirstName, i.LastName, d.TotalAmountDonated
FROM donor_info i
JOIN donor_engagement e ON i.DonorID = e.DonorID
JOIN donation_history d ON i.DonorID = d.DonorID
WHERE e.EngagementScore >= 75;

SELECT 
  i.FirstName, i.LastName, d.TotalAmountDonated, e.EventParticipation
FROM donor_info i
JOIN donor_engagement e ON i.DonorID = e.DonorID
JOIN donation_history d ON i.DonorID = d.DonorID
WHERE e.EventParticipation = 'No' AND d.TotalAmountDonated > 10000;
