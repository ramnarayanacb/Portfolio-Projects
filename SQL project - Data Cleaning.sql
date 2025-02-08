

SELECT 
    COLUMN_NAME,
    DATA_TYPE
FROM 
    PortfolioPorject.INFORMATION_SCHEMA.COLUMNS
WHERE 
    TABLE_NAME = 'Nashville Housing Data for Data Cleaning';


Select * 
From PortfolioPorject..[Nashville Housing Data for Data Cleaning]

---1 Reformating the dates in the below table
Select SaleDate 
From PortfolioPorject..[Nashville Housing Data for Data Cleaning];

--Since i used to import as flat file while importing itself it gets 
--converted to date format

---2 Reformating the address in the below table
Select PropertyAddress
From PortfolioPorject..[Nashville Housing Data for Data Cleaning]
Where PropertyAddress is NULL;
--Since there is null we need to find the reason for it before removing it
Select *
From PortfolioPorject..[Nashville Housing Data for Data Cleaning]
--Where PropertyAddress is NULL
order by ParcelID;
--Populating the property address using self join because of the data
Select o.ParcelID , o.PropertyAddress , p.ParcelID, p.PropertyAddress, ISNULL(o.PropertyAddress, p.PropertyAddress)
From PortfolioPorject..[Nashville Housing Data for Data Cleaning] as o
JOIN PortfolioPorject..[Nashville Housing Data for Data Cleaning] as p
	On o.ParcelID =p.ParcelID
	AND o.UniqueID != p.UniqueID
Where o.PropertyAddress is NULL;

Update o
SET PropertyAddress = ISNULL(o.PropertyAddress, p.PropertyAddress)
From PortfolioPorject..[Nashville Housing Data for Data Cleaning] as o
JOIN PortfolioPorject..[Nashville Housing Data for Data Cleaning] as p
	On o.ParcelID =p.ParcelID
	AND o.UniqueID != p.UniqueID
Where o.PropertyAddress is NULL;
--checking done below
Select *
From PortfolioPorject..[Nashville Housing Data for Data Cleaning]
Where PropertyAddress is NOT NULL;


--We are dividing the property address as address and city 
Select PropertyAddress
From PortfolioPorject..[Nashville Housing Data for Data Cleaning]
--spliting using substring and char index
Select 
SUBSTRING(PropertyAddress,1, CHARINDEX(',', PropertyAddress)-1) as Address,
SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress)+1 , Len(PropertyAddress)) as CityName
From PortfolioPorject..[Nashville Housing Data for Data Cleaning]

Alter TABLE PortfolioPorject..[Nashville Housing Data for Data Cleaning]
Add SplittedPropertyAddress nvarchar(255), SplittedPropertyCityname nvarchar(255);

Update PortfolioPorject..[Nashville Housing Data for Data Cleaning]
SET SplittedPropertyAddress = SUBSTRING(PropertyAddress,1, CHARINDEX(',', PropertyAddress)-1),
SplittedPropertyCityname = SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress)+1 , Len(PropertyAddress))


Select *
--PropertyAddress,
--SplittedPropertyAddress,
--SplittedPropertyCityname
From PortfolioPorject..[Nashville Housing Data for Data Cleaning];

--Step 4 cleaning the owners Address we can use substring method or Parsename 


Select OwnerAddress
From PortfolioPorject..[Nashville Housing Data for Data Cleaning];
-- Parsename works in reverse order in splitting the data inside the column onthis case since there is comma we replaced it with fullstop in order to split 
Select 
PARSENAME(REPLACE(OwnerAddress,',','.'), 3) as SplittedOwnerAddress,
PARSENAME(REPLACE(OwnerAddress,',','.'), 2) as SplittedOwnerCity,
PARSENAME(REPLACE(OwnerAddress,',','.'), 1) as SplittedOwnerState
From PortfolioPorject..[Nashville Housing Data for Data Cleaning];

Alter Table PortfolioPorject..[Nashville Housing Data for Data Cleaning]
ADD SplittedOwnerAddress NVARCHAR(255), SplittedOwnerCity NVARCHAR(255), SplittedOwnerState NVARCHAR(255)

Update PortfolioPorject..[Nashville Housing Data for Data Cleaning]
SET 
SplittedOwnerAddress = PARSENAME(REPLACE(OwnerAddress,',','.'), 3),
SplittedOwnerCity =PARSENAME(REPLACE(OwnerAddress,',','.'), 2) ,
SplittedOwnerState= PARSENAME(REPLACE(OwnerAddress,',','.'), 1);

Select *
From PortfolioPorject..[Nashville Housing Data for Data Cleaning];

--Step 5 cleaning irregularities on Sold as vacant
/*
Now checking back The soldasvacant column converted from yes and no to 0 and 1 ,while importing it converted to this so checked the with the original file  it is yes and no
before and after converting to csv .May be the problem is where i imported this file as flat file 
*/
Select Distinct(SoldAsVacant)
From PortfolioPorject..[Nashville Housing Data for Data Cleaning];

Select SoldAsVacant
From PortfolioPorject..[Nashville Housing Data for Data Cleaning]
Where SoldAsVacant = 1;

Select SoldAsVacant
From PortfolioPorject..[Nashville Housing Data for Data Cleaning]
Where SoldAsVacant = 0;

/*Since we can update the column again by importing or simply changing the dtype of existing col and convert 1 and 0 to yes and no */

Alter Table PortfolioPorject..[Nashville Housing Data for Data Cleaning]
ALTER COLUMN SoldAsVacant VARCHAR(3);

UPDATE PortfolioPorject..[Nashville Housing Data for Data Cleaning]
SET SoldAsVacant = CASE
    WHEN SoldAsVacant = 0 THEN 'No'
    WHEN SoldAsVacant = 1 THEN 'Yes' 
END;

Select SoldAsVacant
From PortfolioPorject..[Nashville Housing Data for Data Cleaning]
Where SoldAsVacant = 'Yes';

Select SoldAsVacant
From PortfolioPorject..[Nashville Housing Data for Data Cleaning]
Where SoldAsVacant = 'No';

Select Distinct(SoldAsVacant), COUNT(SoldAsVacant)
From PortfolioPorject..[Nashville Housing Data for Data Cleaning]
GROUP BY SoldAsVacant
ORDER BY 2;

--Step 6 removing duplicates in the sheet data 
Select * 
From PortfolioPorject..[Nashville Housing Data for Data Cleaning];

WITH RownumCTE AS  
	(Select *,
ROW_NUMBER() OVER(
	PARTITION BY 
	ParcelID,
	PropertyAddress,
	SaleDate,
	SalePrice,
	LegalReference
	Order BY UniqueID
) as row_num
From PortfolioPorject..[Nashville Housing Data for Data Cleaning])

Select * FROM RownumCTE
where row_num =1
Order BY UniqueID;


Select * 
From PortfolioPorject..[Nashville Housing Data for Data Cleaning];

--Step 7 Deleting Unused column 
 Select * 
From PortfolioPorject..[Nashville Housing Data for Data Cleaning];

ALTER TABLE PortfolioPorject..[Nashville Housing Data for Data Cleaning]
DROP COLUMN OwnerAddress,PropertyAddress,TaxDistrict

/*
Select Distinct(LandUse), Count(LandUse)
From PortfolioPorject..[Nashville Housing Data for Data Cleaning]
Group  by LandUse
Order by 1;
*/