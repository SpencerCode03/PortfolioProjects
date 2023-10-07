SELECT * 
FROM Housing..NashvilleHousing

SELECT SaleDateConverted, CONVERT(date, SaleDate)
FROM Housing..NashvilleHousing

ALTER TABLE Housing..NashvilleHousing
ADD SaleDateConverted Date;

UPDATE Housing..NashvilleHousing
SET SaleDateConverted = CONVERT(date, SaleDate)

-- Populate propert address data
SELECT *
FROM Housing..NashvilleHousing
WHERE PropertyAddress IS NULL
ORDER BY ParcelID

SELECT a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, ISNULL(a.PropertyAddress, b.PropertyAddress)
FROM Housing..NashvilleHousing a
JOIN Housing..NashvilleHousing b
	ON a.ParcelID = b.ParcelID 
	AND a.[UniqueID ] <> b.[UniqueID ]
WHERE a.PropertyAddress IS NULL

UPDATE a
SET PropertyAddress = ISNULL(a.PropertyAddress, b.PropertyAddress)
FROM Housing..NashvilleHousing a
JOIN Housing..NashvilleHousing b
	ON a.ParcelID = b.ParcelID 
	AND a.[UniqueID ] <> b.[UniqueID ]

SELECT PropertyAddress
FROM Housing..NashvilleHousing


SELECT 
SUBSTRING(PropertyAddress, 1, CHARINDEX(',' , PropertyAddress) - 1) AS Address,
SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) + 1, Len(PropertyAddress)) AS Address
FROM Housing..NashvilleHousing

ALTER TABLE Housing..NashvilleHousing
ADD PropertySplitAddress NVARCHAR(255);

UPDATE Housing..NashvilleHousing
SET PropertySplitAddress = SUBSTRING(PropertyAddress, 1, CHARINDEX(',' , PropertyAddress) - 1)

ALTER TABLE Housing..NashvilleHousing
ADD PropertySplitCity NVARCHAR(255);

UPDATE Housing..NashvilleHousing
SET PropertySplitCity = SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) + 1, Len(PropertyAddress))

SELECT *
FROM Housing..NashvilleHousing

SELECT OwnerAddress
FROM Housing..NashvilleHousing

SELECT 
PARSENAME(REPLACE(OwnerAddress,',', '.'), 3),
PARSENAME(REPLACE(OwnerAddress,',', '.'), 2),
PARSENAME(REPLACE(OwnerAddress,',', '.'), 1)
FROM Housing..NashvilleHousing

ALTER TABLE Housing..NashvilleHousing
ADD OwnerSplitAddress NVARCHAR(255);

UPDATE Housing..NashvilleHousing
SET OwnerSplitAddress = PARSENAME(REPLACE(OwnerAddress,',', '.'), 3)

ALTER TABLE Housing..NashvilleHousing
ADD OwnerSplitCity NVARCHAR(255);

UPDATE Housing..NashvilleHousing
SET OwnerSplitCity = PARSENAME(REPLACE(OwnerAddress,',', '.'), 2)

ALTER TABLE Housing..NashvilleHousing
ADD OwnerSplitState NVARCHAR(255);

UPDATE Housing..NashvilleHousing
SET OwnerSplitState = PARSENAME(REPLACE(OwnerAddress,',', '.'), 1)

SELECT DISTINCT(SoldAsVacant), COUNT(SoldAsVacant)
FROM Housing..NashvilleHousing
GROUP BY SoldAsVacant
ORDER BY 2

SELECT SoldAsVacant,
CASE WHEN SoldAsVacant = 'Y' THEN 'YES'
	 WHEN SoldAsVacant = 'N' THEN 'NO'
	 ELSE SoldAsVacant
	 END
FROM Housing..NashvilleHousing 



UPDATE Housing..NashvilleHousing
SET SoldAsVacant = CASE WHEN SoldAsVacant = 'Y' THEN 'YES'
		WHEN SoldAsVacant = 'N' THEN 'NO'
		ELSE SoldAsVacant
		END 

;WITH RowNumCTE AS(
SELECT *,
ROW_NUMBER() OVER(
PARTITION BY ParcelID,
			 PropertyAddress, 
			 SalePrice, 
			 SaleDate, 
			 LegalReference
			 ORDER BY 
				UniqueID
					)row_num

FROM Housing..NashvilleHousing
--ORDER BY ParcelID
)
SELECT *
FROM RowNumCTE
WHERE row_num > 1
ORDER BY PropertyAddress

SELECT *
FROM Housing..NashvilleHousing

ALTER TABLE Housing..NashvilleHousing
DROP COLUMN OwnerAddress, TaxDistrict

ALTER TABLE Housing..NashvilleHousing
DROP COLUMN SaleDate


