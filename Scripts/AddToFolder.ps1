#$devConfig = Get-Content "D:\a\IPA-BLG-ARX-GetWork\IPA-BLG-ARX-GetWork\scripts\DevConfig.json" | ConvertFrom-Json
#$BLG_ARX = $devConfig.Folders | Where-Object name -eq 'BLG_ARX' 
function Get-Token {
  $body = @{client_id = $env:ORCH_CLIENT_ID
    grant_type      = 'client_credentials'
    scope           = 'OR.TestSets OR.Execution'
    client_secret   =  $env:ORCH_SECRET
} 
    $tokenResponse = Invoke-RestMethod -Method POST -Uri 'https://cloud.uipath.com/identity_/connect/token' -Headers $header -Body $body -ContentType "application/x-www-form-urlencoded"
    return $tokenResponse.access_token
  }
  #Remove comment
function Get-ProcessInfo {
    param ($Token, $FolderId)   
            
    $header = @{
        Authorization                 = ('Bearer {0}' -f $Token)
        Accept                        = 'application/json'
        "X-UIPATH-OrganizationUnitId"   = $FolderId
    }
    $process = Invoke-RestMethod -Method GET -Uri "https://cloud.uipath.com/myriadgeneticsinc/dev/orchestrator_/odata/Processes?%24filter=contains(Title%2C'GetWork_Tests')&%24orderby=Published%20desc&%24top=1" -Headers $header -ContentType "application/json"
    return $process
}
 
function Add-Process {
    param ($Token, $ProcessData, $FolderId)   
            
      $header = @{
        Authorization                 = ('Bearer {0}' -f $Token)
        Accept                        = 'application/json'
        "X-UIPATH-OrganizationUnitId"   = $FolderId
    }
    
    $body = "{`"ProcessKey`": `"$($ProcessData.value.Title)`", `"ProcessVersion`": `"$($ProcessData.value.Version)`", `"Name`": `"$($ProcessData.value.Title)`", `"FeedId`": `"3077ee65-d537-4db4-a7bc-83bec75224dc`"}"
   
try {
    Invoke-RestMethod -Method POST -Uri "https://cloud.uipath.com/myriadgeneticsinc/dev/orchestrator_/odata/Releases" -Headers $header -body $body -ContentType "application/json"
}
   catch {
        Write-Host "Process exists"
    } 
}

$ProcessData = Get-ProcessInfo -Token ($token = Get-Token) -FolderId 1290191
Add-Process -Token ($token = Get-Token) -ProcessData $ProcessData -FolderId 1290191


