SELECT 
  *  
FROM 
  `my-project-for-data-339119.Housing_data.NashvilleHousingData` 
LIMIT 1000

-- correction of the date format

-- A few lines follow a different format of the string. These are identified via
SELECT
  SaleDate
FROM 
  `my-project-for-data-339119.Housing_data.NashvilleHousingData` 
WHERE
  SAFE.PARSE_DATE('%B %d, %Y', SaleDate) IS NULL

--  excluding the rows with problems in the analysis
SELECT
  SaleDate,
  PARSE_DATE('%B %d, %Y', SaleDate) AS Formatted_Sale_Date
FROM 
  `my-project-for-data-339119.Housing_data.NashvilleHousingData` 
WHERE
  SAFE.PARSE_DATE('%B %d, %Y', SaleDate) IS NOT NULL

-- Working on property address
-- Listing all null data
SELECT
  *
FROM 
  `my-project-for-data-339119.Housing_data.NashvilleHousingData` 
WHERE
  PropertyAddress IS NULL

-- It is possible that parcelID exists somwhere in the data with existing PropertyAddress, so this could be coppied to rows with null input
-- In order to see if such rows exists it is necessary to self join the table
SELECT
  a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress
FROM 
  `my-project-for-data-339119.Housing_data.NashvilleHousingData` a
JOIN
  `my-project-for-data-339119.Housing_data.NashvilleHousingData` b
ON
  a.ParcelID = b.ParcelID AND a.UniqueID <> b.UniqueID
WHERE
  a.PropertyAddress IS NULL

-- The same query as above but adding a column that should be coppied to missing address fields
SELECT
  a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, IFNULL(a.PropertyAddress, b.PropertyAddress) AS AssignedPropAddress
FROM 
  `my-project-for-data-339119.Housing_data.NashvilleHousingData` a
JOIN
  `my-project-for-data-339119.Housing_data.NashvilleHousingData` b
ON
  a.ParcelID = b.ParcelID AND a.UniqueID <> b.UniqueID
WHERE
  a.PropertyAddress IS NULL

-- Updating the fields /not allowed in free tier of Google Cloud / 
UPDATE a
SET PropertyAddress = IFNULL(a.PropertyAddress, b.PropertyAddress)
FROM 
  `my-project-for-data-339119.Housing_data.NashvilleHousingData` a
JOIN
  `my-project-for-data-339119.Housing_data.NashvilleHousingData` b
ON
  a.ParcelID = b.ParcelID AND a.UniqueID <> b.UniqueID
WHERE
  a.PropertyAddress IS NULL

-- dividing address into separate columns
-- STRPOS - returns the position of the character in a string (equivalent to CHARINDEX)
SELECT 
  PropertyAddress,
  SUBSTRING(PropertyAddress, 1, STRPOS(PropertyAddress, ',')) AS Address
FROM 
  `my-project-for-data-339119.Housing_data.NashvilleHousingData` 

-- to remove the comma at the end of the address we can modify the query to
SELECT 
  PropertyAddress,
  SUBSTRING(PropertyAddress, 1, STRPOS(PropertyAddress, ',') - 1) AS Address
FROM 
  `my-project-for-data-339119.Housing_data.NashvilleHousingData` 
WHERE
  STRPOS(PropertyAddress, ',') > 1 -- this is necessary to protect form errors is addres is without ','

-- including city in the next column
SELECT 
  PropertyAddress,
  SUBSTRING(PropertyAddress, 1, STRPOS(PropertyAddress, ',') - 1) AS Address,
  SUBSTRING(PropertyAddress, STRPOS(PropertyAddress, ',') + 1, LENGTH(PropertyAddress)) AS City
FROM 
  `my-project-for-data-339119.Housing_data.NashvilleHousingData` 
WHERE
  STRPOS(PropertyAddress, ',') > 1

-- working on owner address
-- now instead of substring we will try to use other function
SELECT 
  OwnerAddress,
  REGEXP_EXTRACT(OwnerAddress, r'(.*?),') AS OwnerStreet,
  REGEXP_EXTRACT(OwnerAddress, r',(.*?),') AS OwnerTown,
  REGEXP_EXTRACT(OwnerAddress, r'(?:(?:.*?),){2}(.*)') AS OwnerState
FROM 
  `my-project-for-data-339119.Housing_data.NashvilleHousingData` 
WHERE
  OwnerAddress IS NOT NULL

-- trying to alter table /addition of a column works in a free tier of bigquery/
ALTER TABLE `my-project-for-data-339119.Housing_data.NashvilleHousingData` 
ADD COLUMN OwnerStreet STRING

-- update of the column /not possible in free tier of bigquery/
UPDATE `my-project-for-data-339119.Housing_data.NashvilleHousingData` 
SET OwnerStreet = REGEXP_EXTRACT(OwnerAddress, r'(.*?),')

-- looking at values in column SoldAsVacant
SELECT 
  DISTINCT(SoldAsVacant)
FROM 
  `my-project-for-data-339119.Housing_data.NashvilleHousingData` 

-- including count of how many entries are there
SELECT 
  DISTINCT(SoldAsVacant),
  COUNT(SoldAsVacant)
FROM 
  `my-project-for-data-339119.Housing_data.NashvilleHousingData` 
GROUP BY
  SoldAsVacant

-- unifying N to No and Y to Yes
SELECT 
  SoldAsVacant,
  CASE WHEN SoldAsVacant = 'N' THEN 'No'
      WHEN SoldAsVacant = 'Y' THEN 'Yes'
      WHEN SoldAsVacant <> 'Y' AND SoldAsVacant <> 'Yes' AND SoldAsVacant <> 'No' AND SoldAsVacant <> 'N' THEN 'No'
      ELSE SoldAsVacant
  END
FROM 
  `my-project-for-data-339119.Housing_data.NashvilleHousingData` 

-- Correcting the table (not working in free tier of Bigquery)
UPDATE  `my-project-for-data-339119.Housing_data.NashvilleHousingData` 
SET SoldAsVacant = CASE WHEN SoldAsVacant = 'N' THEN 'No'
      WHEN SoldAsVacant = 'Y' THEN 'Yes'
      WHEN SoldAsVacant <> 'Y' AND SoldAsVacant <> 'Yes' AND SoldAsVacant <> 'No' AND SoldAsVacant <> 'N' THEN 'No'
      ELSE SoldAsVacant
  END

-- bypassing this problem with no possibility to update columns in free tier of bigquery
WITH HousingData AS 
(
  SELECT 
  SoldAsVacant,
  CASE WHEN SoldAsVacant = 'N' THEN 'No'
      WHEN SoldAsVacant = 'Y' THEN 'Yes'
      WHEN SoldAsVacant <> 'Y' AND SoldAsVacant <> 'Yes' AND SoldAsVacant <> 'No' AND SoldAsVacant <> 'N' THEN 'No'
      ELSE SoldAsVacant
  END AS SoldAsVacantCorr
FROM 
  `my-project-for-data-339119.Housing_data.NashvilleHousingData`
)
SELECT
  DISTINCT(SoldAsVacantCorr),
  COUNT(SoldAsVacantCorr)
FROM
  HousingData
GROUP BY
  SoldAsVacantCorr

-- looking at duplicates
SELECT
  *,
  ROW_NUMBER() OVER 
  (
    PARTITION BY ParcelID,
                PropertyAddress,
                SalePrice,
                SaleDate,
                LegalReference
    ORDER BY UniqueID
  ) Row_num
FROM 
  `my-project-for-data-339119.Housing_data.NashvilleHousingData`

-- listing duplicates
WITH Row_data AS
(
  SELECT
  *,
  ROW_NUMBER() OVER 
  (
    PARTITION BY ParcelID,
                PropertyAddress,
                SalePrice,
                SaleDate,
                LegalReference
    ORDER BY UniqueID
  ) Row_num
FROM 
  `my-project-for-data-339119.Housing_data.NashvilleHousingData`
)
SELECT
  *
FROM
  Row_data
WHERE
  Row_num > 1

-- dropping columns
ALTER TABLE `my-project-for-data-339119.Housing_data.NashvilleHousingData` 
DROP COLUMN TaxDistrict