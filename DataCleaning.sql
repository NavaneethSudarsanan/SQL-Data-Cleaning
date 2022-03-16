SELECT *
FROM HousingData

--Standardise Date Format
SELECT SaleDate,CONVERT(date,SaleDate)
FROM HousingData


ALTER TABLE HousingData
ADD SaleDateConverted date

UPDATE HousingData
SET SaleDateConverted=CONVERT(date,SaleDate)

--Populate Property Address data
SELECT * 
FROM HousingData
WHERE PropertyAddress IS NULL

SELECT a.ParcelID,a.PropertyAddress,b.ParcelID,b.PropertyAddress
FROM HousingData a
JOIN HousingData b
	ON a.ParcelID=b.ParcelID
	AND a.[UniqueID ]<>b.[UniqueID ]
WHERE a.PropertyAddress IS NULL

UPDATE a
SET a.PropertyAddress=ISNULL(a.PropertyAddress,b.PropertyAddress)
FROM HousingData a
JOIN HousingData b
	ON a.ParcelID=b.ParcelID
	AND a.[UniqueID ]<>b.[UniqueID ]
WHERE a.PropertyAddress IS NULL

--Breaking out address into different columns (Address,City,State)
SELECT PropertyAddress
FROM HousingData

SELECT
SUBSTRING(PropertyAddress,1,CHARINDEX(',',PropertyAddress)-1) AS Address,
SUBSTRING(PropertyAddress,CHARINDEX(',',PropertyAddress)+1,LEN(PropertyAddress)) AS Address
FROM HousingData

ALTER TABLE HousingData
ADD PropertySplitAddress nvarchar(255)

UPDATE HousingData
SET PropertySplitAddress=SUBSTRING(PropertyAddress,1,CHARINDEX(',',PropertyAddress)-1)
FROM HousingData

ALTER TABLE HousingData
ADD PropertyCity nvarchar(255)

UPDATE HousingData
SET PropertyCity=SUBSTRING(PropertyAddress,CHARINDEX(',',PropertyAddress)+1,LEN(PropertyAddress))
FROM HousingData

SELECT OwnerAddress
FROM HousingData

SELECT
PARSENAME(REPLACE(OwnerAddress,',','.'),3),
PARSENAME(REPLACE(OwnerAddress,',','.'),2),
PARSENAME(REPLACE(OwnerAddress,',','.'),1)
FROM HousingData

ALTER TABLE HousingData
ADD OwnerSplitAddress nvarchar(255)

UPDATE HousingData
SET OwnerSplitAddress=PARSENAME(REPLACE(OwnerAddress,',','.'),3)
FROM HousingData

ALTER TABLE HousingData
ADD OwnerCity nvarchar(255)

UPDATE HousingData
SET OwnerCity=PARSENAME(REPLACE(OwnerAddress,',','.'),2)
FROM HousingData

ALTER TABLE HousingData
ADD OwnerState nvarchar(255)

UPDATE HousingData
SET OwnerState=PARSENAME(REPLACE(OwnerAddress,',','.'),1)
FROM HousingData

--Change Y and N as Yes and No in 'SoldAsVacant' column
SELECT DISTINCT SoldAsVacant
FROM HousingData

SELECT SoldAsVacant,
CASE
	WHEN SoldAsVacant='Y' THEN 'Yes'
	WHEN SoldAsVacant='N' THEN 'No'
	ELSE SoldAsVacant
	END
FROM HousingData

UPDATE HousingData
SET SoldAsVacant=CASE
	WHEN SoldAsVacant='Y' THEN 'Yes'
	WHEN SoldAsVacant='N' THEN 'No'
	ELSE SoldAsVacant
	END
FROM HousingData

--Remove unused columns
ALTER TABLE HousingData
DROP COLUMN SaleDate

SELECT *
FROM HousingData


