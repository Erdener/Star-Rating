#     Star Rating - Calculate your maps star rating from the downloaded Business Profile data in a given date range. (Google™, Google Maps™ mapping service and Google My Business™ business listing service are trademarks of Google LLC.)
#     Copyright (C) 2023 Erdener Tuna

#     This program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.

#    This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.

#    You should have received a copy of the GNU General Public License along with this program. If not, see <https://www.gnu.org/licenses/>. 

Write-Output "Star Rating  Copyright (C) 2023 Erdener Tuna`nThis program comes with ABSOLUTELY NO WARRANTY.`nThis is free software, and you are welcome to redistribute it under certain conditions.`nYou should have received a copy of the GNU General Public License along with this program. If not, see <https://www.gnu.org/licenses/>.`n`n"

# Date range
$startDate = Get-Date "2023-01-01T00:00:00"
$endDate = Get-Date "2023-03-31T23:59:59"

# Select .json files
$jsonFiles = Get-ChildItem -Path ".\" -Recurse -Include "reviews*.json"

# Create an array to store the "starRating" fields
$starRatings = @()

# Process each .json file
foreach ($jsonFile in $jsonFiles) {
    # Read file and convert from JSON
    $jsonContent = Get-Content $jsonFile.FullName | ConvertFrom-Json
    
    # Process "reviews" entries
    foreach ($review in $jsonContent.reviews) {
        # Check "updateTime" field
        $updateTime = Get-Date $review.updateTime
        if ($updateTime -ge $startDate -and $updateTime -le $endDate) {
            # Check the "starRating" field and convert it to digit
            $starRating = switch ($review.starRating) {
                "ONE" {1}
                "TWO" {2}
                "THREE" {3}
                "FOUR" {4}
                "FIVE" {5}
            }
            # Add "starRating" value to array
            $starRatings += $starRating
        }
    }
}

# Calculate and print the average of "starRating" values
if ($starRatings.Count -gt 0) {
    $averageRating = ($starRatings | Measure-Object -Average).Average
    Write-Host "Average Star Rating: $averageRating"
} else {
    Write-Host "There is no data in the specified date range."
}
