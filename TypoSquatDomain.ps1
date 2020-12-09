function New-TypoSquatDomain {
    param (
        $DomainName
    )
    $ReplacementGylph = [pscustomobject]@{
        0  = 'b', 'd' 
        1  = 'b', 'lb' 
        2  = 'c', 'e'
        3  = 'd', 'b'
        4  = 'd', 'cl'
        5  = 'd', 'dl' 
        6  = 'e', 'c' 
        7  = 'g', 'q' 
        8  = 'h', 'lh' 
        9  = 'i', '1'
        10 = 'i', 'l' 
        11 = 'k', 'lk'
        12 = 'k', 'ik'
        13 = 'k', 'lc' 
        14 = 'l', '1'
        15 = 'l', 'i' 
        16 = 'm', 'n'
        17 = 'm', 'nn'
        18 = 'm', 'rn'
        19 = 'm', 'rr' 
        20 = 'n', 'r'
        21 = 'n', 'm'
        22 = 'o', '0'
        23 = 'o', 'q'
        24 = 'q', 'g' 
        25 = 'u', 'v' 
        26 = 'v', 'u'
        27 = 'w', 'vv'
        28 = 'w', 'uu' 
        29 = 'z', 's' 
        30 = 'n', 'r' 
        31 = 'r', 'n'
    }
    $i = 0

    $TLD = $DomainName -split '\.' | Select-Object -last 1
    $DomainName = $DomainName -split '\.' | Select-Object -First 1
    $HomoGlyph = do {
        $NewDomain = $DomainName -replace $ReplacementGylph.$i
        $NewDomain
        $NewDomain + 's'
        $NewDomain + 'a'
        $NewDomain + 't'
        $NewDomain + 'en'
        $i++
    } while ($i -lt 29)

    $i = 0
    $BitSquatAndOmission = do {
        $($DomainName[0..($i)] -join '') + $($DomainName[($i + 2)..$DomainName.Length] -join '')
        $($DomainName[0..$i] -join '') + $DomainName[$i + 2] + $DomainName[$i + 1] + $($DomainName[($i + 3)..$DomainName.Length] -join '')
        $i++
    } while ($i -lt $DomainName.Length)
    $Plurals = $DomainName + 's'; $DomainName + 'a'; $domainname + 'en' ;  ; $DomainName + 't'

    $CombinedDomains = $HomoGlyph + $BitSquatAndOmission + $Plurals | ForEach-Object { "$($_).$($TLD)" }
    return ( $CombinedDomains | Sort-Object -Unique | Where-Object { $_ -ne $DomainName })
}

function Get-O365TypoSquats {
    param (
        $TypoSquatedDomain
    )
    $DomainWithoutTLD = $TypoSquatedDomain -split '.' | Select-Object -First 1
    $DomainTest = Resolve-DnsName -Type A "$($TypoSquatedDomain)" -ErrorAction SilentlyContinue
    $Onmicrosoft = Resolve-DnsName -Type A "$($DomainWithoutTLD).onmicrosoft.com" -ErrorAction SilentlyContinue
    $Sharepoint = Resolve-DnsName -Type A "$($DomainWithoutTLD).sharepoint.com" -ErrorAction SilentlyContinue
    [PSCustomObject]@{
        'Onmicrosoft test' = [boolean]$Onmicrosoft
        'Sharepoint test'  = [boolean]$Sharepoint
        'Domain test'      = [boolean]$DomainTest
        Domain             = $TypoSquatedDomain
    }
}

New-TypoSquatDomain -DomainName 'Google.com' | ForEach-Object { Get-O365TypoSquats -TypoSquatedDomain $_ }
