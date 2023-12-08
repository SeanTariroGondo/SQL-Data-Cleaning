/*

Cleaning Data in SQL using Queries

*/


Select *
From [Housing].[dbo].[Tbl_Housing_Data]

--------------------------------------------------------------------------------------------------------------------------

-- Standardize Date Format


Select saleDate, CONVERT(Date,SaleDate) as SaleDateConverted
From [Housing].[dbo].[Tbl_Housing_Data]


Update [Housing].[dbo].[Tbl_Housing_Data]
SET SaleDate = CONVERT(Date,SaleDate)

-- If it doesn't Update properly

ALTER TABLE [Housing].[dbo].[Tbl_Housing_Data]
Add SaleDateConverted Date;

Update [Housing].[dbo].[Tbl_Housing_Data]
SET SaleDateConverted = CONVERT(Date,SaleDate)


 --------------------------------------------------------------------------------------------------------------------------

-- Populate Property Address data

Select *
From [Housing].[dbo].[Tbl_Housing_Data]
order by ParcelID



Select a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, ISNULL(a.PropertyAddress,b.PropertyAddress)
From [Housing].[dbo].[Tbl_Housing_Data] a
JOIN [Housing].[dbo].[Tbl_Housing_Data] b
	on a.ParcelID = b.ParcelID
	AND a.[UniqueID ] <> b.[UniqueID ]
Where a.PropertyAddress is null


Update a
SET PropertyAddress = ISNULL(a.PropertyAddress,b.PropertyAddress)
From [Housing].[dbo].[Tbl_Housing_Data] a
JOIN [Housing].[dbo].[Tbl_Housing_Data] b
	on a.ParcelID = b.ParcelID
	AND a.[UniqueID ] <> b.[UniqueID ]
Where a.PropertyAddress is null




--------------------------------------------------------------------------------------------------------------------------

-- Breaking out Address into Individual Columns (Address, City, State)


Select PropertyAddress
From [Housing].[dbo].[Tbl_Housing_Data]


SELECT
SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1 ) as Address
, SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) + 1 , LEN(PropertyAddress)) as Address
From [Housing].[dbo].[Tbl_Housing_Data]


ALTER TABLE [Housing].[dbo].[Tbl_Housing_Data]
Add PropertySplitAddress Nvarchar(255);

Update [Housing].[dbo].[Tbl_Housing_Data]
SET PropertySplitAddress = SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1 )


ALTER TABLE [Housing].[dbo].[Tbl_Housing_Data]
Add PropertySplitCity Nvarchar(255);

Update [Housing].[dbo].[Tbl_Housing_Data]
SET PropertySplitCity = SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) + 1 , LEN(PropertyAddress))




Select *
From [Housing].[dbo].[Tbl_Housing_Data]





Select OwnerAddress
From [Housing].[dbo].[Tbl_Housing_Data]


Select
PARSENAME(REPLACE(OwnerAddress, ',', '.') , 3) as Address
,PARSENAME(REPLACE(OwnerAddress, ',', '.') , 2) as City
,PARSENAME(REPLACE(OwnerAddress, ',', '.') , 1) as state
From [Housing].[dbo].[Tbl_Housing_Data]



ALTER TABLE [Housing].[dbo].[Tbl_Housing_Data]
Add OwnerSplitAddress Nvarchar(255);

Update [Housing].[dbo].[Tbl_Housing_Data]
SET OwnerSplitAddress = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 3)


ALTER TABLE [Housing].[dbo].[Tbl_Housing_Data]
Add OwnerSplitCity Nvarchar(255);

Update [Housing].[dbo].[Tbl_Housing_Data]
SET OwnerSplitCity = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 2)



ALTER TABLE [Housing].[dbo].[Tbl_Housing_Data]
Add OwnerSplitState Nvarchar(255);

Update [Housing].[dbo].[Tbl_Housing_Data]
SET OwnerSplitState = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 1)



Select *
From [Housing].[dbo].[Tbl_Housing_Data] where isnull(yearbuilt,0) <> 0




--------------------------------------------------------------------------------------------------------------------------


-- Change Y and N to Yes and No in "Sold as Vacant" field


Select Distinct(SoldAsVacant), Count(SoldAsVacant)
From [Housing].[dbo].[Tbl_Housing_Data]
Group by SoldAsVacant
order by 2

ALTER TABLE [Housing].[dbo].[Tbl_Housing_Data]
Add Soldasvacantconverted varchar(10);

Update [Housing].[dbo].[Tbl_Housing_Data]
SET Soldasvacantconverted = Soldasvacant



Select SoldAsVacant
, CASE When Soldasvacantconverted = '1' THEN 'Yes'
	   When Soldasvacantconverted = '0' THEN 'No'
	   ELSE Soldasvacantconverted 
	   END as Soldasvacantconverted
From [Housing].[dbo].[Tbl_Housing_Data]


Update [Housing].[dbo].[Tbl_Housing_Data]
SET Soldasvacantconverted = CASE When Soldasvacantconverted = '1' THEN 'Yes'
	   When Soldasvacantconverted = '0' THEN 'No'
	   ELSE Soldasvacantconverted 
	   END 






-----------------------------------------------------------------------------------------------------------------------------------------------------------

-- Remove Duplicates

WITH RowNumCTE AS(
Select *,
	ROW_NUMBER() OVER (
	PARTITION BY ParcelID,
				 PropertyAddress,
				 SalePrice,
				 SaleDate,
				 LegalReference
				 ORDER BY
					UniqueID
					) row_num

From [Housing].[dbo].[Tbl_Housing_Data]

)
Select *
From RowNumCTE
Where row_num > 1
Order by PropertyAddress



Select *
From [Housing].[dbo].[Tbl_Housing_Data]




---------------------------------------------------------------------------------------------------------

-- Delete Unused Columns



Select *
From [Housing].[dbo].[Tbl_Housing_Data]


ALTER TABLE [Housing].[dbo].[Tbl_Housing_Data]
DROP COLUMN OwnerAddress, PropertyAddress, SoldAsVacant


