
-- Check the data

Select *
from PortofolioProject.dbo.NashvilleHousing



-- Standardize Date Format

Select SaleDate, CONVERT(date, SaleDate)
from PortofolioProject.dbo.NashvilleHousing

-- Update existing data in a table based on certain conditions
Update NashvilleHousing
SET SaleDate = CONVERT(date, SaleDate)

-- Change the structure of a table that has been created
ALTER TABLE NashvilleHousing
add SaleDateConverted Date;

Update NashvilleHousing
SET SaleDateConverted = CONVERT(date, SaleDate)

Select SaleDateConverted, CONVERT(date, SaleDate)
from PortofolioProject.dbo.NashvilleHousing



-- Populate Property Address Data

Select PropertyAddress
from PortofolioProject.dbo.NashvilleHousing

-- See if there are nulls in the data
Select *
from PortofolioProject.dbo.NashvilleHousing
Where PropertyAddress is null

-- Sort the results of a data set in a specific order
Select *
from PortofolioProject.dbo.NashvilleHousing
order by ParcelID

-- Checking if there is the same data that has null by combining them and comparing them then filling the null value with the same data
Select a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, ISNULL(a.PropertyAddress,b.PropertyAddress)
From PortofolioProject.dbo.NashvilleHousing a -- create aliases in order to compare them
JOIN PortofolioProject.dbo.NashvilleHousing b -- compare them to join related or relational tables or columns
	on a.ParcelID = b.ParcelID -- is used in conjunction with the JOIN statement to specify conditions that define how two or more tables are linked or joined 
	AND a.[UniqueID ] <> b.[UniqueID ] -- The AND operator displays data if all AND-separated conditions are TRUE
Where a.PropertyAddress is null -- to filter rows in a table based on certain conditions


Update a -- Update the PropertyAddress value in table a (an alias of NashvilleHousing)
SET PropertyAddress = ISNULL(a.PropertyAddress,b.PropertyAddress) -- If the PropertyAddress value in a is NULL, it is filled with the value from table b (rows with the same ParcelID but different UniqueID)
From PortofolioProject.dbo.NashvilleHousing a
JOIN PortofolioProject.dbo.NashvilleHousing b
	on a.ParcelID = b.ParcelID
	AND a.[UniqueID ] <> b.[UniqueID ]
Where a.PropertyAddress is null

-- Breaking out address into individual columns (address, city, update)
-- Property address

Select Propertyaddress
From PortofolioProject.dbo.NashvilleHousing

Select 
SUBSTRING(Propertyaddress, 1, CHARINDEX(',', Propertyaddress) -1) as Address
,SUBSTRING(Propertyaddress, CHARINDEX(',', Propertyaddress) +1, LEN(Propertyaddress)) as City

From PortofolioProject.dbo.NashvilleHousing

ALTER TABLE NashvilleHousing
add PropertySplitAddress Nvarchar(255);

Update NashvilleHousing
SET PropertySplitAddress = SUBSTRING(Propertyaddress, 1, CHARINDEX(',', Propertyaddress) -1)

ALTER TABLE NashvilleHousing
add PropertySplitCity Nvarchar(255);

Update NashvilleHousing
SET PropertySplitCity = SUBSTRING(Propertyaddress, CHARINDEX(',', Propertyaddress) +1, LEN(Propertyaddress))

Select *
From PortofolioProject.dbo.NashvilleHousing

-- Owner Address

Select Owneraddress
from PortofolioProject.dbo.NashvilleHousing

Select
PARSENAME(REPLACE(Owneraddress, ',', '.'), 3),
PARSENAME(REPLACE(Owneraddress, ',', '.'), 2),
PARSENAME(REPLACE(Owneraddress, ',', '.'), 1)
From PortofolioProject.dbo.NashvilleHousing

ALTER TABLE NashvilleHousing
add OwnerSplitAddress Nvarchar(255);

Update NashvilleHousing
SET OwnerSplitAddress = PARSENAME(REPLACE(Owneraddress, ',', '.'), 3)

ALTER TABLE NashvilleHousing
add OwnerSplitCity Nvarchar(255);

Update NashvilleHousing
SET OwnerSplitCity = PARSENAME(REPLACE(Owneraddress, ',', '.'), 2)

ALTER TABLE NashvilleHousing
add OwnerSplitState Nvarchar(255);

Update NashvilleHousing
SET OwnerSplitState = PARSENAME(REPLACE(Owneraddress, ',', '.'), 1)

Select *
From PortofolioProject.dbo.NashvilleHousing

-- Change Y and N to Yes and No in "Sold as Vacant" field

Select distinct(SoldASVacant), Count(SoldASVacant)
From PortofolioProject.dbo.NashvilleHousing
Group by SoldASVacant
order by 2

Select SoldASVacant
, CASE When SoldASVacant = 'Y' THEN 'Yes'
	   When SoldASVacant = 'N' THEN 'No'
	   Else SoldASVacant
	   END
From PortofolioProject.dbo.NashvilleHousing

UPDATE NashvilleHousing
Set SoldAsVacant = CASE When SoldASVacant = 'Y' THEN 'Yes'
	   When SoldASVacant = 'N' THEN 'No'
	   Else SoldASVacant
	   END

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
From PortofolioProject.dbo.NashvilleHousing
)
Select *
From RowNumCTE
Where row_num > 1
Order by PropertyAddress

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
From PortofolioProject.dbo.NashvilleHousing
)
DELETE
From RowNumCTE
Where row_num > 1

-- Delete Unused Columns 

Select *
From PortofolioProject.dbo.NashvilleHousing

ALTER TABLE PortofolioProject.dbo.NashvilleHousing
DROP COLUMN OwnerAddress, TaxDistrict, PropertyAddress, SaleDate