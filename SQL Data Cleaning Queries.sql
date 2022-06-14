/*

1). Cleaning Data With SQL Queries

*/

Select *
from PortfolioProject..NashvilleHousing;


----------------------------------------------------------------

2). -- Standardize Date Format

Select SaleDate, CONVERT(Date,SaleDate)
From PortfolioProject..NashvilleHousing;

Update PortfolioProject..Nashvillehousing
SET SaleDate = Convert(Date,Saledate);

Alter Table PortfolioProject..NashvilleHousing
Add SaleDateConverted Date;

Update PortfolioProject..Nashvillehousing
Set SaleDateConverted = Convert(Date,SaleDate);

Select SaleDateConverted
From PortfolioProject..NashvilleHousing;

Alter Table PortfolioProject..NashvilleHousing
Drop column saledate; 

----------------------------------------------------------------

3).-- Populate Property Address Data

Select *
From PortfolioProject..NashvilleHousing
Order by ParcelID

Select NH.ParcelID, NH.PropertyAddress, NH2.ParcelID, NH2.PropertyAddress, ISNULL(NH.PropertyAddress,NH2.PropertyAddress)
From PortfolioProject..NashvilleHousing NH 
Join PortfolioProject..NashvilleHousing NH2
On NH.ParcelID = NH2.ParcelID
And NH.[UniqueID ] <> NH2.[UniqueID ]
Where NH.PropertyAddress is null

Update NH
SET PropertyAddress = ISNULL(NH.PropertyAddress,NH2.PropertyAddress)
From PortfolioProject..NashvilleHousing NH
Join PortfolioProject..NashvilleHousing NH2
On NH.ParcelID = NH2.ParcelID
And NH.[UniqueID ] <> NH2.[UniqueID ]
Where NH.PropertyAddress is null




----------------------------------------------------------------

4). -- Breaking out Address into Individual Columns (Address, City, State)


Select *
From PortfolioProject..NashvilleHousing

Select
SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1) as Address
, SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress)  +1, LEN(PropertyAddress)) as Address
From PortfolioProject..NashvilleHousing;

Alter Table PortfolioProject..NashvilleHousing
Add PropertySplitAddress Nvarchar(255);

Update PortfolioProject..NashvilleHousing
Set PropertySplitAddress = SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1) 

Alter Table PortfolioProject..NashvilleHousing
Add PropertySplitCity Nvarchar(255)

Update PortfolioProject..Nashvillehousing
Set PropertySplitCity = SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress)  +1, LEN(PropertyAddress)) 

Select * 
From PortfolioProject..NashvilleHousing


Select OwnerAddress
From PortfolioProject..NashvilleHousing

Select 
PARSENAME(Replace(OwnerAddress, ',' , '.'), 3), 
PARSENAME(Replace(OwnerAddress, ',' , '.'), 2),
PARSENAME(Replace(OwnerAddress, ',' , '.'), 1)
From PortfolioProject..NashvilleHousing

Alter Table PortfolioProject..NashvilleHousing
Add OwnerSplitAddress Nvarchar(255)

Update PortfolioProject..NashvilleHousing
Set OwnerSplitAddress = PARSENAME(Replace(OwnerAddress, ',' , '.'), 3)

Alter Table PortfolioProject..NashvilleHousing
Add OwnerSplitCity Nvarchar(255)

Update PortfolioProject..NashvilleHousing
Set OwnerSplitCity = PARSENAME(Replace(OwnerAddress, ',' , '.'), 2)

Alter Table PortfolioProject..NashvilleHousing
Add OwnerSplitState Nvarchar(255)

Update PortfolioProject..Nashvillehousing
Set OwnerSplitState = PARSENAME(Replace(OwnerAddress, ',' , '.'), 3)

-------------------------------------------------------------------------------------

5) -- Change 'Y' and 'N' to 'Yes' and 'No' in 'Sold at Vacant' Field

Select Distinct(SoldAsVacant), COUNT(SoldAsVacant)
From PortfolioProject..NashvilleHousing
Group by SoldAsVacant
Order by 2

Select SoldAsVacant
, CASE When SoldAsVacant = 'Y' THEN 'Yes'
When SoldAsVacant = 'N' THEN 'No'
Else SoldAsVacant
End
From PortfolioProject..NashvilleHousing

Update PortfolioProject..NashvilleHousing
Set SoldAsVacant =
Case When SoldAsVacant = 'Y' then 'Yes'
When SoldAsVacant = 'N' then 'No'
Else SoldAsVacant
End
From PortfolioProject..NashvilleHousing


-------------------------------------------------------------

6) -- Remove Duplicates
With RowNumCTE AS(
Select *,
Row_Number() Over ( 
Partition by ParcelID,
			 PropertyAddress,
			 SalePrice,
			 SaleDateConverted,
			 LegalReference
			 order By UniqueID
			 ) Row_Num
From PortfolioProject..NashvilleHousing
)
Delete 
From RowNumCTE
Where Row_Num > 1

----------------------------------------------------

7). -- Delete Unused Columns

Select *
From PortfolioProject..NashvilleHousing

ALTER TABLE portfolioproject..NashvilleHousing
DROP COLUMN Owneraddress, TaxDistrict, PropertyAddress, SaledDate



